
class ModeFeedback extends Mode
{
  PImage pig = loadImage("pig_feeding.jpg"); 
  PImage gun = loadImage("gun.jpg"); 
  PImage chocolate = loadImage("maltesers.jpg"); 

  color ledColour;
  int currentLightPostion;
  int currentNumLights;
    
  ModeFeedback() {
    cp5.addTab("feedback")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(1)
      ;
  }

  //------------------------------------------------------------------------
  void setup() {
  }

  //------------------------------------------------------------------------
  void setColour() {
    String testColour = testList.get( currentTestIndex ).LED_Color;
    println("colour = " + testColour);

    if ( testColour.equals("red")) {
      ledColour = colours.red;
    } else if ( testColour.equals("orange")) {
      ledColour = colours.orange;
    } else if ( testColour.equals("yellow")) {
      ledColour = colours.yellow;
    } else if ( testColour.equals("green")) {
      ledColour = colours.green;
    } else if ( testColour.equals("blue")) {
      ledColour = colours.blue;
    } else if ( testColour.equals("purple")) {
      ledColour = colours.purple;
    } else if ( testColour.equals("white")) {
      ledColour = colours.white;
    } else if ( testColour.equals("pink")) {
      ledColour = colours.pink;
    } else if ( testColour.equals("aqua")) {
      ledColour = colours.aqua;
    }
    
  }

  //------------------------------------------------------------------------
  void uploadLedColours() {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = SET_COLOURS;

    arduino.valuesToSend[3] = testList.get( currentTestIndex ).numLights;
    arduino.valuesToSend[4] = testList.get( currentTestIndex ).lightPosition;

    // arduino.valuesToSend[3] = Num LEDS's to use
    // arduino.valuesToSend[4] = Middle index of LED position 
    // arduino.valuesToSend[5] = RED 
    // arduino.valuesToSend[6] = GREEN  
    // arduino.valuesToSend[7] = BLUE

    arduino.valuesToSend[5] = (int)red(ledColour);  
    arduino.valuesToSend[6] = (int)green(ledColour);  
    arduino.valuesToSend[7] = (int)blue(ledColour);

    arduino.sendValues();
  }

  //------------------------------------------------------------------------
  void resetLedColours() {
    ledColour = color(0, 0, 0);
    currentLightPostion = testList.get(currentTestIndex).lightPosition;
    currentNumLights = testList.get(currentTestIndex).numLights;
    testList.get(currentTestIndex).lightPosition = 27;
    testList.get(currentTestIndex).numLights = 54;
  }
  //------------------------------------------------------------------------
  void resumeLedColours() {
    testList.get(currentTestIndex).lightPosition = currentLightPostion;
    testList.get(currentTestIndex).numLights = currentNumLights;
  }

  //------------------------------------------------------------------------
  void sendFeedback(int numMaltesers, int airBlastDuration, int bPlaySound) {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = FEEDBACK;
    arduino.valuesToSend[3] = numMaltesers; // = 0.0
    arduino.valuesToSend[4] = airBlastDuration; // = 0.0
    arduino.valuesToSend[5] = bPlaySound; // = 1
    arduino.sendValues();
  }

  //------------------------------------------------------------------------
  void setActivePads() {
    int testNum = testList.get( currentTestIndex ).testID;
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = RUN;
    if (testNum == 1) {
      arduino.valuesToSend[3] = 1;
      arduino.valuesToSend[4] = 1;
      arduino.valuesToSend[5] = 1;
    } else if ( testNum == 2) {
      arduino.valuesToSend[3] = 0;
      arduino.valuesToSend[4] = 1;
      arduino.valuesToSend[5] = 0;
    }
    arduino.sendValues();
  }

  //------------------------------------------------------------------------
  void setPauseState() {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = STOP;
    arduino.sendValues();
  }

  //------------------------------------------------------------------------
  void draw()
  {
    background( 255 );
    pushStyle();

    int lightPosition = testList.get( currentTestIndex ).lightPosition;
    int numLights = testList.get( currentTestIndex ).numLights;
    int startIndex = lightPosition - (numLights/2);
    int endIndex = lightPosition + (numLights/2);

    //println("currentTestIndex = " + currentTestIndex);
    // Check if our start position is even or not
    if (numLights %  2 > 0) {
      startIndex -= 1;
    }

    int count = 0;
    for (int i = 0; i < 54; i++) {
      if ( i >= startIndex && i < endIndex) {
        fill(ledColour);
      } else {
        fill(0, 0, 0);
      }
      rect((18*count)+33, 320, 9, 9);
      count++;
    }

    popStyle();
    
    // Draw test progress as text
    fill(0);
    textSize(32);
    text("Test Type = " + testList.get( currentTestIndex ).testID, (width/2)-180, 65);
    text("Current Prompt = " + (currentTestIndex + 1) + " out of " + numTests, (width/2)-180, 100);
    
    //draw pig
    fill(255);
    image(pig, (width/2)-180, height/2, 360, 240);

    //draw chocolate
    if (bDrawChocolate) {
      image(chocolate, 50, height/2, 240, 150);
    }

    //draw gun
    else if (bDrawGun) {
      image(gun, (width/1.2)-120, height/2, 240, 150);
    }
  }

  //------------------------------------------------------------------------
  void mousePressed()
  {
  }

  //------------------------------------------------------------------------
  void keyPressed()
  { 
    //if ( key == 'q' || key == ESC )
      //abortTest();
  }
}