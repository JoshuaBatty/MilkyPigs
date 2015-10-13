static final int WIDTH = 1024;
static final int HEIGHT = 768;

//Set human readable enums for Modes
static final int START = 0;
static final int PROMPT = 1;
static final int PAUSE = 2;
static final int CHOOSE = 3;

static final int TEST = 0;
static final int FEEDBACK = 1;
static final int SETUP = 2;

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
ArduinoSend arduinoSend;

Boolean init = false;

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
  arduinoSend = new ArduinoSend(this); // call the constructor of ArduinoSend

  //noCursor();

  filename = "output/data " + year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute()+ "-" + second() + ".csv" ;

  numTests = 0;
  loadInput();
  initOutput();

  currentTestIndex = 0;

  //Initiating order is important - must match order of enums respective integers 
  modes.add( new ModeTest() );
  modes.add( new ModeFeedback() );
  modes.add( new ModeSetup() );

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
      } 
      else if (name.equals("ledZone2")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone2Colour(cp5.get(ColorWheel.class, "ledZone2").getRGB());
      }
      else if (name.equals("ledZone3")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone3Colour(cp5.get(ColorWheel.class, "ledZone3").getRGB());
      }
      else if (name.equals("ledZone4")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone4Colour(cp5.get(ColorWheel.class, "ledZone4").getRGB());
      }
      else if (name.equals("ledZone5")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone5Colour(cp5.get(ColorWheel.class, "ledZone5").getRGB());
      }
      else if (name.equals("ledZone6")) {
        ModeFeedback modeFeedback = (ModeFeedback)modes.get(FEEDBACK);
        modeFeedback.setZone6Colour(cp5.get(ColorWheel.class, "ledZone6").getRGB());
      }
      
      //----------------- KILL SWITCH
      if (name.equals("KillSwitch")) {
        mode = TEST;
        cp5.getTab("default").bringToFront();
        cp5.getTab("default").setActive(true);
        cp5.getTab("default").setOpen(true);

        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(0);

        for (int i = 0; i < 7; i++) {
          if (i == 0) arduinoSend.valuesToSend[0] = M;
          else if (i == 1) arduinoSend.valuesToSend[1] = P;
          else arduinoSend.valuesToSend[i] = 0;
        }
        arduinoSend.sendValues();
      }

      //----------------- TEST MODE
      if (name.equals("Test1")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(1);
      } else if (name.equals("Test2")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(2);
      } else if (name.equals("Test3")) {
        ModeTest modeTest = (ModeTest)modes.get(mode);
        modeTest.setTestMode(3);
      }
      if (name.equals("StartTest")) {
        mode = FEEDBACK;
        cp5.getTab("feedback").bringToFront();
        cp5.getTab("feedback").setActive(true);
        cp5.getTab("feedback").setOpen(true);

        arduinoSend.valuesToSend[2] = 1;
        arduinoSend.sendValues();
      }

      //----------------- SETUP MODE
      if (name.equals("timeOut")) {
        arduinoSend.valuesToSend[3] = (int)control.getValue();
      } else if (name.equals("touchSensitivity")) {
        arduinoSend.valuesToSend[4] = (int)control.getValue();
      } else if (name.equals("dispenseMaltesers")) {
        arduinoSend.valuesToSend[5] = (int)control.getValue();
      } else if (name.equals("airBlast")) {
        arduinoSend.valuesToSend[6] = (int)control.getValue();
      } else if (name.equals("SetNewValues")) {
        arduinoSend.sendValues();
      }

    }
  }
}


//--------------------------------------
//DRAW
void draw()
{
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
//--------------------------------------