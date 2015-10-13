
class ModeSetup extends Mode
{
  int timeOut = 10;
  int touchSensitivity = 200;
  int dispenseMaltesers = 0;
  int airBlast = 0;

  int num_led_zones = 6;

  ModeSetup() {
    int sliderWidth = 380;
    int sliderHeight = 50;
    int colourWheelWidth = 160;
    int yOffset = 0;

    cp5.addTab("setup")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(1)
      ;

    for (int i = 0; i < num_led_zones; i++) {
      cp5.addColorWheel("ledZone"+str(1+i), 30+(colourWheelWidth*i), 140, colourWheelWidth ).setRGB(color(0, 0, 0));
    }

    cp5.addSlider("timeOut")
      .setPosition((width/2)-(sliderWidth/2), yOffset+360)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(timeOut)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("touchSensitivity")
      .setPosition((width/2)-(sliderWidth/2), yOffset+360)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(touchSensitivity)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("dispenseMaltesers")
      .setPosition((width/2)-(sliderWidth/2), yOffset+360)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(dispenseMaltesers)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("airBlast")
      .setPosition((width/2)-(sliderWidth/2), yOffset+360)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(airBlast)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    cp5.addButton("DefaultValues")
      .setValue(0)
      .setPosition((width/2)-190, 630)
      .setSize(180, 39)
      ;
    cp5.addButton("SetNewValues")
      .setValue(0)
      .setPosition((width/2)+10, 630)
      .setSize(180, 39)
      ;

    for (int i = 0; i < num_led_zones; i++) {
      cp5.getController("ledZone"+str(1+i)).moveTo("setup");
    }

    cp5.getController("timeOut").moveTo("setup");
    cp5.getController("touchSensitivity").moveTo("setup");
    cp5.getController("dispenseMaltesers").moveTo("setup");
    cp5.getController("airBlast").moveTo("setup");
    cp5.getController("DefaultValues").moveTo("setup");
    cp5.getController("SetNewValues").moveTo("setup");
  }

  void init() {
    timeOut = 10;
    touchSensitivity = 200;
    dispenseMaltesers = 0;
    airBlast = 0;

    cp5.getController("timeOut").setValue(timeOut);
    cp5.getController("touchSensitivity").setValue(touchSensitivity);
    cp5.getController("dispenseMaltesers").setValue(dispenseMaltesers);
    cp5.getController("airBlast").setValue(airBlast);

    arduinoSend.valuesToSend[3] = timeOut;
    arduinoSend.valuesToSend[4] = touchSensitivity;
    arduinoSend.valuesToSend[5] = dispenseMaltesers;
    arduinoSend.valuesToSend[6] = airBlast;
    arduinoSend.sendValues();

    for (int i = 0; i < num_led_zones; i++) {
      ColorWheel cw = (ColorWheel)cp5.getController("ledZone"+str(1+i));
      cw.setRGB(color(random(255), random(255), random(255)));
    }
  }

  void setup() {
  }

  void draw()
  {
    int prompt = testList.get( currentTestIndex ).promptList.get( currentPromptIndex );
    background( 255 );
  }

  void mousePressed()
  {
  }


  void press( String colour )
  {
    int l = millis() - startTime;
    int p = testList.get( currentTestIndex ).promptList.get( currentPromptIndex );
    String r = colour;
    String correctColour = testList.get( currentTestIndex ).correctResponseList.get( currentPromptIndex );

    println( "response is: " + colour );
    println( "correct response is: " + correctColour );

    //check response against response list and play sound if required
    //if( colour ==  correctColour || correctColour == "all" ) sound.play();
    // if( colour.equals( correctColour ) || correctColour.equals("all") )
    //{
    //  println("MATCH!");
    //  sound.play();
    //}

    PromptResponse response = new PromptResponse( p, r, l );
    currentTestResult.responseList.add( response );


    currentPromptIndex++;

    if ( currentPromptIndex < testList.get( currentTestIndex ).numPrompts )
      mode = PAUSE;
    else
      endTest();
  }


  void keyPressed()
  {
    if ( key == 'q' || key == ESC )
      abortTest();
  }


  void endTest()
  {
    //TEST FINISHED
    currentTestResult.end();
    resultList.add( currentTestResult );
    println( "number of results = " + resultList.size() );
    currentPromptIndex = 0;
    currentTestIndex = 0;

    //change state
    //--------------
    mode = CHOOSE;
  }
}