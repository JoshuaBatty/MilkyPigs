class ModeFeedback extends Mode
{
  PImage pig = loadImage("pig_feeding.jpg"); 
  PImage gun = loadImage("gun.jpg"); 
  PImage chocolate = loadImage("maltesers.jpg"); 

  color ledColour[] = new color[6];

  ModeFeedback() {
    cp5.addTab("feedback")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(2)
      ;
  }
  
  //------------------------------------------------------------------------
  void setup() {
  }

  //------------------------------------------------------------------------
  void setZone1Colour(color c) {
    ledColour[0] = c;
  }
  void setZone2Colour(color c) {
    ledColour[1] = c;
  }
  void setZone3Colour(color c) {
    ledColour[2] = c;
  }
  void setZone4Colour(color c) {
    ledColour[3] = c;
  }
  void setZone5Colour(color c) {
    ledColour[4] = c;
  }
  void setZone6Colour(color c) {
    ledColour[5] = c;
  }

  //------------------------------------------------------------------------
  void uploadLedColours() {
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = SET_COLOURS;
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 3; j++) {
        if ( j == 0) arduino.valuesToSend[3+(i*3)] = (int)red(ledColour[i]);  
        else if ( j == 1) arduino.valuesToSend[4+(i*3)] = (int)green(ledColour[i]);  
        else if ( j == 2) arduino.valuesToSend[5+(i*3)] = (int)blue(ledColour[i]);
      }
    }
    arduino.sendValues();
  }
  
  //------------------------------------------------------------------------
  void sendFeedback(int numMaltesers, int airBlastDuration, int bPlaySound){
    arduino.valuesToSend[0] = M;
    arduino.valuesToSend[1] = P;
    arduino.valuesToSend[2] = FEEDBACK;
    arduino.valuesToSend[3] = numMaltesers;
    arduino.valuesToSend[4] = airBlastDuration;
    arduino.valuesToSend[5] = bPlaySound;
    arduino.sendValues();
  }

  //------------------------------------------------------------------------
  void draw()
  {
    background( 255 );
    pushStyle();

    int count = 0;
    for (int j = 0; j < 6; j++) {
      for (int i = 0; i < 9; i++) {
        fill( ledColour[j] );
        rect((18*count)+33, 320, 9, 9);
        count++;
      }
    }
    popStyle();

    //draw pig
    image(pig, (width/2)-180, height/2, 360, 240);
    
    //draw chocolate
    if(buttonPressed.equals("1")) {
       image(chocolate, 50, height/2, 240, 150);
    }
  
    //draw gun
    else if (buttonPressed.equals("3")) {
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
    if ( key == 'q' || key == ESC )
      abortTest();
  }
}