
class ModeSetup extends Mode
{
  int timeOut = 10;
  int touchSensitivity = 200;
  int dispenseMaltesers = 0;
  int airBlast = 0;
  int pauseTestDuration = 5; // This is in seconds

  ModeSetup() {
    int sliderWidth = 380;
    int sliderHeight = 50;
    int yOffset = 0;

    cp5.addTab("default")
      .setLabel("setup")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(0)
      ;

    cp5.addTextfield("PigID")
      .setPosition((width/2)-100, 140)
      .setSize(200, 39)
      .setFont(createFont("arial", 20))
      .setColor(color(255, 0, 0))
      .setColorLabel(color(0))
      .setColorBackground(color(255, 255, 0))
      .setAutoClear(false)
      ;

    cp5.addSlider("timeOut")
      .setPosition((width/2)-(sliderWidth/2), yOffset+220)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(timeOut)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("touchSensitivity")
      .setPosition((width/2)-(sliderWidth/2), yOffset+220)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(touchSensitivity)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("pauseDuration")
      .setPosition((width/2)-(sliderWidth/2), yOffset+220)
      .setRange(0, 20)
      .setSize(sliderWidth, sliderHeight)
      .setValue(pauseTestDuration)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    cp5.addButton("DefaultValues")
      .setValue(0)
      .setPosition((width/2)-190, 430)
      .setSize(180, 39)
      ;
    cp5.addButton("SetNewValues")
      .setValue(0)
      .setPosition((width/2)+10, 430)
      .setSize(180, 39)
      ;

    cp5.addButton("SelfTest")
      .setValue(0)
      .setPosition(width-200, 390)
      .setSize(180, 79)
      ;

    PImage[] imgs = {loadImage("StartTestButton_off.jpg"), loadImage("StartTestButton_over.jpg"), loadImage("StartTestButton_clicked.jpg")};
    cp5.addButton("StartTest")
      .setValue(0)
      .setPosition((width/2)-(280/2), height/2+120)
      .setImages(imgs)
      .setBroadcast(true)
      .updateSize()
      .activateBy(cp5.RELEASE)
      ;

    cp5.getController("timeOut").moveTo("default");
    cp5.getController("touchSensitivity").moveTo("default");
    cp5.getController("DefaultValues").moveTo("default");
    cp5.getController("SetNewValues").moveTo("default");
    cp5.getController("SelfTest").moveTo("default");
    cp5.getController("PigID").moveTo("default");
    cp5.getController("StartTest").moveTo("default");
  }

  //----------------------------------------------
  void init() {
    timeOut = 10;
    touchSensitivity = 200;
    pauseTestDuration = 5;

    cp5.getController("timeOut").setValue(timeOut);
    cp5.getController("touchSensitivity").setValue(touchSensitivity);
    cp5.getController("pauseDuration").setValue(pauseTestDuration);

    setNewValues();
  }

  //----------------------------------------------
  void runSelfTest() {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = SELF_TEST;
    arduino.sendValues();
  }

  //----------------------------------------------
  void setNewValues() {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = SETTINGS;
    arduino.valuesToSend[3] = timeOut;
    arduino.valuesToSend[4] = touchSensitivity;
    arduino.valuesToSend[5] = pauseTestDuration;
    arduino.sendValues();
  }

  //----------------------------------------------
  void setup() {
  }

  //----------------------------------------------
  void draw()
  {
    //int prompt = testList.get( currentTestIndex ).promptList.get( currentPromptIndex );
    background( 255 );
  }

  //----------------------------------------------
  void mousePressed()
  {
  }


  //----------------------------------------------
  void saveResponse()
  {
    int prompt = currentTestIndex;
    int testType = testList.get( currentTestIndex ).testID;
    String reactionTime = testDuration;

    int lightPosition = testList.get( currentTestIndex ).lightPosition;
    int numLights = testList.get( currentTestIndex ).numLights;
    String LED_colour = testList.get( currentTestIndex ).LED_Color;
    int padPressed = parseInt(buttonPressed); // This comes from the arduino receive class in main script

    bDrawChocolate = false;
    bDrawGun = false;

    if (testType == 1) {
      println("test Type = 1");
      if (padPressed == 1) { // If the left pad was pushed
        println("padPressed = 1");
        dispenseMaltesers = testList.get(currentTestIndex).leftReward;
        airBlast = 0;
        bDrawChocolate = true;
        bDrawGun = false;
      } else if (padPressed == 3) { // If the right pad was pushed
        println("padPressed = 3");
        dispenseMaltesers = testList.get(currentTestIndex).rightReward;
        airBlast = 0;
        bDrawChocolate = true;
        bDrawGun = false;
      } else if (padPressed == 2) {
        println("padPressed = 2");
        dispenseMaltesers = 0; // If the middle pad was pushed set numMaltesers = 0;
        airBlast = testList.get( currentTestIndex ).wrongResponse;
        bDrawChocolate = false;
        bDrawGun = true;
      } else if (padPressed == 0) {
        println("padPressed = 0");
        dispenseMaltesers = 0; 
        airBlast = 0;
        bDrawChocolate = false;
        bDrawGun = false;
      }
    } else if (testType == 2) {
      println("test Type = 2");
      // If no Pad was pressed then it has timed out. 
      if (padPressed == 0) {
        bDrawChocolate = false;
        bDrawGun = false;
        airBlast = 0;
        dispenseMaltesers = 0;
      } 
      // Else if we get a respnse from the middle pad then do something
      // Ignore pads, 1 & 3
      else if (padPressed == 2) {
        if (testList.get(currentTestIndex).correctResponse > 0) {
          dispenseMaltesers = testList.get(currentTestIndex).correctResponse;
          airBlast = 0;
          bDrawChocolate = true;
          bDrawGun = false;
        } else if (testList.get(currentTestIndex).wrongResponse > 0) {
          dispenseMaltesers = 0;
          airBlast = testList.get( currentTestIndex ).wrongResponse;
          bDrawChocolate = false;
          bDrawGun = true;
        }
      } 
    }


    PromptResponse response = new PromptResponse( prompt, testType, reactionTime, lightPosition, numLights, 
      padPressed, dispenseMaltesers, airBlast, LED_colour );

    currentTestResult = new TestResult( testList.get(currentTestIndex) );
    currentTestResult.responseList.add( response );

    //currentPromptIndex++;

    //if ( currentPromptIndex < testList.get( currentTestIndex ).numPrompts ) {
    //  // mode = PAUSE;
    //} else {
    endTest();
    //}
  }


  void keyPressed()
  {
    //if ( key == 'q' || key == ESC )
     // abortTest();
  }


  void endTest()
  {
    //TEST FINISHED
    currentTestResult.end();
    resultList.add( currentTestResult );
    println( "number of results = " + resultList.size() );
    // currentPromptIndex = 0;
    // currentTestIndex = 0;

    //change state
    //--------------
    //mode = CHOOSE;
  }
}