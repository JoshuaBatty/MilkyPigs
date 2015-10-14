static final int WIDTH = 1024;
static final int HEIGHT = 768;

//Set human readable enums for Modes
static final int START = 0;
static final int PROMPT = 1;
static final int PAUSE = 2;
static final int CHOOSE = 3;

static final int TEST = 0;
static final int SETUP = 1;
//static final int FEEDBACK = 2;

int mode = CHOOSE;

ArrayList<Mode> modes = new ArrayList<Mode>();

String filename;
int startTime;
String name;

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

// Arduino Send Receive 
Arduino arduino;

Boolean init = false;
Boolean bReset = false; // This is used to trigger init() on the main thread in draw();

//SETUP
//--------------------------------------
void setup()
{
  size( 1024, 768 );
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

  // Arduino 
  arduino = new Arduino(this); // call the constructor of arduino

  //noCursor();

  filename = "output/data " + year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute()+ "-" + second() + ".csv" ;

  numTests = 0;
  loadInput();
  initOutput();

  currentTestIndex = 0;

  //Initiating order is important - must match order of enums respective integers 
  modes.add( new ModeTest() );
  modes.add( new ModeSetup() );
  modes.add( new ModeFeedback() );

  mode = TEST;

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

      //----------------- FEEDBACK MODE
      if (name.equals("ledZone1")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone1Colour(cp5.get(ColorWheel.class, "ledZone1").getRGB());
      } else if (name.equals("ledZone2")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone2Colour(cp5.get(ColorWheel.class, "ledZone2").getRGB());
      } else if (name.equals("ledZone3")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone3Colour(cp5.get(ColorWheel.class, "ledZone3").getRGB());
      } else if (name.equals("ledZone4")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone4Colour(cp5.get(ColorWheel.class, "ledZone4").getRGB());
      } else if (name.equals("ledZone5")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone5Colour(cp5.get(ColorWheel.class, "ledZone5").getRGB());
      } else if (name.equals("ledZone6")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone6Colour(cp5.get(ColorWheel.class, "ledZone6").getRGB());
      }

      //----------------- KILL SWITCH
      if (name.equals("KillSwitch")) {
        init();

        for (int i = 0; i < 7; i++) {
          if (i == 0) arduino.valuesToSend[0] = M;
          else if (i == 1) arduino.valuesToSend[1] = P;
          else if (i == 2) arduino.valuesToSend[2] = STOP;
          else arduino.valuesToSend[i] = 0;
        }
        arduino.sendValues();
      }

      //----------------- TEST MODE
      if (name.equals("Test1")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(1);
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        String[] colours = loadStrings("data/ColourPalettes/test1Colours.txt");
        for (int i =0; i<colours.length; i++) {
          modeSetup.setWheelColour(i, int(colours[i]));
        }
      } else if (name.equals("Test2")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(2);
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        String[] colours = loadStrings("data/ColourPalettes/test2Colours.txt");
        for (int i =0; i<colours.length; i++) {
          modeSetup.setWheelColour(i, int(colours[i]));
        }
      } else if (name.equals("Test3")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(3);
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        String[] colours = loadStrings("data/ColourPalettes/test3Colours.txt");
        for (int i =0; i<colours.length; i++) {
          modeSetup.setWheelColour(i, int(colours[i]));
        }
      }
      if (name.equals("StartTest")) {
        mode = FEEDBACK;
        cp5.getTab("feedback").bringToFront();
        cp5.getTab("feedback").setActive(true);
        cp5.getTab("feedback").setOpen(true);

        // Upload the LED colours first 
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.uploadLedColours();

        // Then Put into start test mode
        ModeTest modeTest = (ModeTest)modes.get(TEST);
        arduino.valuesToSend[0] = M;
        arduino.valuesToSend[1] = P;
        arduino.valuesToSend[2] = RUN;
        modeTest.uploadPadStates();
        arduino.sendValues();
      }

      //----------------- SETUP MODE
      if (name.equals("timeOut")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.timeOut = (int)control.getValue();
      } else if (name.equals("touchSensitivity")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.touchSensitivity = (int)control.getValue();
      } else if (name.equals("dispenseMaltesers")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.dispenseMaltesers = (int)control.getValue();
      } else if (name.equals("airBlast")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.airBlast = (int)control.getValue();
      } else if (name.equals("SetNewValues")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.setNewValues();
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.uploadLedColours();
      } else if (name.equals("DefaultValues")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.init();
      } else if (name.equals("SelfTest")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        modeSetup.runSelfTest();
      } else if (name.equals("Set Test 1 Colours")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeSetup.test1Colours = modeFeedback.ledColour;
        saveStrings("data/ColourPalettes/test1Colours.txt", str(modeSetup.test1Colours));
      } else if (name.equals("Set Test 2 Colours")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeSetup.test2Colours = modeFeedback.ledColour;
        saveStrings("data/ColourPalettes/test2Colours.txt", str(modeSetup.test1Colours));
      } else if (name.equals("Set Test 3 Colours")) {
        ModeSetup modeSetup = (ModeSetup)modes.get(SETUP);
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeSetup.test3Colours = modeFeedback.ledColour;
        saveStrings("data/ColourPalettes/test3Colours.txt", str(modeSetup.test1Colours));
      }
    }
  }
}

//--------------------------------------
void init() {
  mode = TEST;
  cp5.getTab("default").bringToFront();
  cp5.getTab("default").setActive(true);
  cp5.getTab("default").setOpen(true);

  ModeTest modeTest = (ModeTest)modes.get(mode);
  modeTest.setTestMode(0);
}

//--------------------------------------
//DRAW
void draw()
{
  // If serialEvent is called on another thread
  if(bReset == true){
    init();
    bReset = false;
  }
  
  modes.get(mode).draw();
  // background(cp5.get(ColorWheel.class, "ledZone1").getRGB());
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
  modes.get(mode).keyPressed();

  if ( key == 'q' || key == ESC )
  {
    println("exit");
    writeResults();
    exit();
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


void initOutput()
{
  outTable = new Table();
  outTable.addColumn("id");
  outTable.addColumn("name");
  outTable.addColumn("start date");
  outTable.addColumn("start time");
  outTable.addColumn("end time");
  outTable.addColumn("total time (ms)");
  outTable.addColumn("num prompts");

  for ( int i = 1; i <= 30; i++ )
  {
    outTable.addColumn("prompt " + i );
    outTable.addColumn("response " + i );
    outTable.addColumn("latency " + i );
  }
}


void writeResults()
{
  for ( TestResult result : resultList )
  {
    TableRow row = outTable.addRow();
    row.setString( 0, result.id );
    row.setString( 1, result.name );
    row.setString( 2, result.startDate );
    row.setString( 3, result.startTime );
    row.setString( 4, result.endTime );
    row.setInt( 5, result.totalMillis );
    row.setInt( 6, result.numPrompts );

    for ( int i = 0; i < result.responseList.size (); i++ )
    {
      row.setInt( i * 3 + 7, result.responseList.get( i ).prompt );
      row.setString( i * 3 + 8, result.responseList.get( i ).response ); 
      row.setInt( i * 3 + 9, result.responseList.get( i ).latency );
    }
  }
  saveTable( outTable, filename );
}

// Each time we see incoming data this method gets called. 
//---------------------------------------------
void serialEvent( Serial arduinoPort) {
  String serial = "";

  println("Receiving data");
  while (arduinoPort.available () > 0) { //as long as there is data coming from serial port, read it and store it
    serial = arduinoPort.readStringUntil(10);
    println(serial);
  }  
  if (serial != null) { // if the string is not empty, print the following
    String[] a = split(serial, ','); // a new array (called 'a') that stores values into seperate cells (seperated by commas specified in your Arduino program)

    if (a[0] == "MP") {
      currentTestResult.buttonPressed = a[1];
      currentTestResult.testDuration = a[2];

      println(a[0]); // This should be MP
      println("buttonPressed = " + currentTestResult.buttonPressed);
      println("testDuration = " + currentTestResult.testDuration);
      bReset = true;
    }
  }
}


//--------------------------------------