
class ModeSetup extends Mode
{
  ModeSetup() {
    int sliderWidth = 380;
    int sliderHeight = 50;
    int colourWheelWidth = 440;
    int yOffset = 0;

    cp5.addTab("setup")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(2)
      ;

    cp5.addColorWheel("ledColours", (width/2)-(colourWheelWidth/4), 10, colourWheelWidth/2 ).setRGB(color(128, 0, 255));

    cp5.addSlider("timeOut")
      .setPosition((width/2)-(sliderWidth/2), yOffset+250)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(10)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("touchSensitivity")
      .setPosition((width/2)-(sliderWidth/2), yOffset+250)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(200)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("dispenseMaltesers")
      .setPosition((width/2)-(sliderWidth/2), yOffset+250)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(0)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    yOffset += sliderHeight+10;

    cp5.addSlider("airBlast")
      .setPosition((width/2)-(sliderWidth/2), yOffset+250)
      .setRange(0, 255)
      .setSize(sliderWidth, sliderHeight)
      .setValue(0)
      .setColorValue(255)
      .setColorLabel(0)
      ;

    cp5.getController("ledColours").moveTo("setup");
    cp5.getController("timeOut").moveTo("setup");
    cp5.getController("touchSensitivity").moveTo("setup");
    cp5.getController("dispenseMaltesers").moveTo("setup");
    cp5.getController("airBlast").moveTo("setup");
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