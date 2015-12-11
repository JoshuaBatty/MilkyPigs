
//Set human readable enums for Modes
static final int START = 0;
static final int PROMPT = 1;
static final int CHOOSE = 3;

static final int SETUP = 0;

int mode = CHOOSE;

ArrayList<Mode> modes = new ArrayList<Mode>();

String filename;
String name;
int startTime;

int numTests;
int currentTestIndex;
int currentPromptIndex;

ArrayList<Test> testList = new ArrayList<Test>();
ArrayList<TestResult> resultList = new ArrayList<TestResult>();
TestResult currentTestResult;

Table inTable;
Table outTable;

//---------------------------- Josh Additions
// GUI Library 
import controlP5.*;
ControlP5 cp5;
ControlP5 guiKill;
ControlP5 guiPause;

// Arduino Send Receive 
Arduino arduino;

// Colours
Colours colours;

Boolean bDrawChocolate = false;
Boolean bDrawGun = false;

Boolean init = false;
Boolean bSendFeedback = false;
Boolean bButtonPressed = false; // This is set to true when a response from the pig has been received
// It is then set to false as soon as the pause timer starts. 
Boolean bResume = true; // Make sure that scott is ready to recieve new values

String buttonPressed = "";
String testDuration = "";
String PigName = "";
int timer = -3000;

//SETUP
//--------------------------------------
void setup()
{
  size( 1024, 768 );
  // fullScreen();
  background( 255 );
  ellipseMode( CENTER );
  rectMode( CENTER );

  // GUI 
  cp5 = new ControlP5(this);
  guiKill = new ControlP5(this);
  guiKill.addButton("KillSwitch")
    .setValue(0)
    .setPosition((width-190), 20)
    .setSize(170, 79)
    .setColorForeground(color(255, 0, 0))
    .setColorBackground(color(205, 0, 0));
  ;
  guiPause = new ControlP5(this);
  guiPause.addToggle("PauseToggle")
    .setValue(0)
    .setPosition((width-190), 110)
    .setSize(170, 79)
    .setColorForeground(color(20, 255, 200))
    .setColorBackground(color(25, 255, 100))
    .setColorLabel(color(0));
  ;

  // Arduino 
  arduino = new Arduino(this); // call the constructor of arduino

  // Colours
  colours = new Colours();

  numTests = 0;
  loadInput();
  initOutput();

  currentTestIndex = 0;

  //Initiating order is important - must match order of enums respective integers 
  modes.add( new ModeSetup() );
  modes.add( new ModeFeedback() );

  mode = SETUP;

  init = true;
}

//--------------------------------------
// RECEIVE GUI EVENTS
public void controlEvent(ControlEvent theEvent) {

  if (init == true) {
    if (theEvent.isController()) {
      String name = theEvent.getController().getName();
      Controller control = theEvent.getController();
      println(name);

      ModeFeedback modeFeedback = (ModeFeedback)modes.get(RUN);
      ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);

      //----------------- KILL SWITCH
      if (name.equals("KillSwitch")) {
        writeResults();
        init();

        for (int i = 0; i < 7; i++) {
          if (i == 0) arduino.valuesToSend[0] = M;
          else if (i == 1) arduino.valuesToSend[1] = P;
          else if (i == 2) arduino.valuesToSend[2] = STOP;
          else arduino.valuesToSend[i] = 0;
        }
        arduino.sendValues();
      }

      //----------------- PAUSE SWITCH
      if (name.equals("PauseToggle")) {
        if ((int)control.getValue() == 1) {
          pause();
          // Send a Pause command to the arduino
          modeFeedback.setPauseState();
        } else if ((int)control.getValue() == 0) {
          currentTestIndex--; // down iterate the testIndex so that the same prompt is presented as before
          nextPrompt();
        }
      }


      //----------------- SETUP MODE
      if (name.equals("PigID")) {
        PigName = cp5.get(Textfield.class, "PigID").getText();
        filename = "output/" + PigName + " " + year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute()+ "-" + second() + ".csv" ;
      } else if (name.equals("timeOut")) {
        modeSetup.timeOut = (int)control.getValue();
      } else if (name.equals("touchSensitivity")) {
        modeSetup.touchSensitivity = (int)control.getValue();
      } else if (name.equals("pauseDuration")) {
        modeSetup.pauseTestDuration = (int)control.getValue();
      } else if (name.equals("SetNewValues")) {
        modeSetup.setNewValues();
        modeFeedback.uploadLedColours();
      } else if (name.equals("DefaultValues")) {
        modeSetup.init();
      } else if (name.equals("SelfTest")) {
        modeSetup.runSelfTest();
      } else if (name.equals("StartTest")) {
        mode = RUN;
        cp5.getTab("feedback").bringToFront();
        cp5.getTab("feedback").setActive(true);
        cp5.getTab("feedback").setOpen(true);

        // Upload the LED colours first 
        modeFeedback.setColour();
        modeFeedback.uploadLedColours();

        // Then Put into start test mode
        modeFeedback.setActivePads();
      }
    }
  }
}

//--------------------------------------
void init() {
  mode = SETUP;
  cp5.getTab("default").bringToFront();
  cp5.getTab("default").setActive(true);
  cp5.getTab("default").setOpen(true);

  buttonPressed = "";
  PigName = "";
  cp5.get(Textfield.class, "PigID").clear();
}

//DRAW
//--------------------------------------
void draw() {
  if (bSendFeedback == true) {
    ModeFeedback modeFeedback = (ModeFeedback)modes.get(RUN);
    ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
    modeFeedback.sendFeedback(modeSetup.dispenseMaltesers, modeSetup.airBlast, 1);
    timer = millis();
    bSendFeedback = false;
  }

  // Pig chooses a pad, reward or punishment is administered, LED colours are set to off, “pause for ’n’ seconds”, next prompt...
  if (bButtonPressed == true) {
    pause();

    int ellapsedTime = millis() - timer;
    ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);

  println("Ellapsed Time = " + ellapsedTime);
  println("pause Duration = " + modeSetup.pauseTestDuration);
  
    if (ellapsedTime > (modeSetup.pauseTestDuration*1000) && bResume == true) {
      nextPrompt();
      startTime = millis();
    }
  }

  modes.get(mode).draw();
  
}

//--------------------------------------
void pause() {
  ModeFeedback modeFeedback = (ModeFeedback)modes.get(RUN);
  modeFeedback.resetLedColours();
}

//--------------------------------------
void nextPrompt() {
  if (currentTestIndex < (numTests-1)) {
    currentTestIndex++;
    ModeFeedback modeFeedback = (ModeFeedback)modes.get(RUN);
    modeFeedback.setColour();
    modeFeedback.uploadLedColours();
    modeFeedback.setActivePads();
  }
  bResume = false;
  bButtonPressed = false;

  bDrawChocolate = false;
  bDrawGun = false;
}

//--------------------------------------
//TOUCHES (clicks)
void mousePressed()
{
  modes.get(mode).mousePressed();
}

//--------------------------------------
//KEYPRESSES
void keyPressed()
{
  if (key == '1') {
    receiveButtonPressed("1", "1000");
  } else if (key == '2') {
    receiveButtonPressed("2", "1000");
  } else if (key == '3') {
    receiveButtonPressed("3", "1000");
  }

  if ( key == 'r') {
    bResume = true;
    println("RESUME DELIVERY");
  }
 
  if ( key == 'q' || key == ESC )
  {
    println("exit");
    writeResults();
  } else if (key == 's') {
    writeResults();
  }
}


//--------------------------------------
//IO HANDLING
void loadInput()
{
  inTable = loadTable("input/input.csv", "header");

  numTests = inTable.getRowCount();
  println(numTests + " tests found\n"); 

  for ( TableRow row : inTable.rows () ) 
    testList.add(new Test( row ) );
}


//--------------------------------------
void initOutput()
{
  outTable = new Table();
  outTable.addColumn("Pig Name");
  outTable.addColumn("Start Date");
  outTable.addColumn("Start Time");
  outTable.addColumn("End Time");
  outTable.addColumn("Num Prompts");
  outTable.addColumn("Time Out");
  outTable.addColumn("Touch Sensitivity");
  outTable.addColumn("Pause Duration");

  outTable.addColumn("Prompt Number");
  outTable.addColumn("Test Type");
  outTable.addColumn("Reaction Time");
  outTable.addColumn("Light Position");
  outTable.addColumn("Num Lights");
  outTable.addColumn("Colour");
  outTable.addColumn("Pad Pressed");
  outTable.addColumn("Num Maltesers");
  outTable.addColumn("Air Blast Duration");
}

/*
0. Pig Name
 1. Start Date
 2. Start Time
 3. End Time
 4. Number of Prompts
 5. Time Out Value
 6. Touch Sensitivity 
 7. Pause Duration 
 
 ———————————————————————
 8. Prompt Number
 9. Test Type 
 10. ReactionTime
 11. Light Position
 12. Num Lights
 13. Colour 
 14. Pad Pressed
 15. Num Maltesers  
 16. Air Blast Duration 
 */

//--------------------------------------
void writeResults()
{
  ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
  modeSetup.endTest();

  int counter = 0;
  for ( TestResult result : resultList )
  {
    TableRow row = outTable.addRow();
    if (counter == 0) {
      row.setString( 0, PigName );
      row.setString( 1, result.startDate );
      row.setString( 2, result.startTime );
      row.setString( 3, hour() + ":" + minute()+ ":" + second() );
      row.setInt( 4, numTests );
      row.setFloat( 5, modeSetup.timeOut );
      row.setFloat( 6, modeSetup.touchSensitivity );
      row.setFloat( 7, modeSetup.pauseTestDuration );
    }
    for ( int i = 0; i < result.responseList.size(); i++ )
    {
      //row = outTable.addRow();

      row.setInt(8, 1 + result.responseList.get( i ).prompt );
      row.setInt(9, result.responseList.get( i ).testType );
      row.setString(10, result.responseList.get( i ).reactionTime );
      row.setInt(11, result.responseList.get( i ).lightPosition );
      row.setInt(12, result.responseList.get( i ).numLights );
      row.setString(13, result.responseList.get( i ).colour );
      row.setInt(14, result.responseList.get( i ).padPressed ); 
      row.setInt(15, result.responseList.get( i ).numMaltesers ); 
      row.setInt(16, result.responseList.get( i ).airBlastDuration );
    }

    if (counter == resultList.size()) {
      println("counter = " + counter);
      outTable.removeRow(outTable.getRowCount());
    }

    counter++;
  }
  saveTable( outTable, filename );
}


//--------------------------------------
void receiveButtonPressed(String padNumber, String reactionTime) {
  buttonPressed = padNumber;
  testDuration = reactionTime; // This is actually t he reaction Time i want

  bButtonPressed = true;
  timer = millis();

  println("buttonPressed = " + buttonPressed);
  println("testDuration = " + testDuration);

  bSendFeedback = true;
  bResume = false;
  ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
  modeSetup.saveResponse();
}

// Each time we see incoming data this method gets called. 
//---------------------------------------------
void serialEvent( Serial arduinoPort) {
  String serial = "";

  println("Receiving data");
  while (arduinoPort.available () > 0) { //as long as there is data coming from serial port, read it and store it
    serial = arduinoPort.readStringUntil(10);
  }  
  if (serial != null) { // if the string is not empty, print the following
    String[] a = split(serial, ','); // a new array (called 'a') that stores values into seperate cells (seperated by commas specified in your Arduino program)
    println("a[0] = " + a[0]);

    if (a[0].equals("MP")) {
      println("a[0] = " + a[0]);
      println("a[1] = " + a[1]);
      println("a[2] = " + a[2]);

      receiveButtonPressed(a[1], a[2]);
    }
    if (a[0].equals("MR")) {
      bResume = true;
      println("RESUME DELIVERY");
    }
  }
}