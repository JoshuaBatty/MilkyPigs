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
      .setId(1)
      ;
  }
  void setup() {
  }

  void setZone1Colour(color c) {
    ledColour[0] = c;
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[3] = (int)red(c);
    arduinoSend.valuesToSend[4] = (int)green(c);
    arduinoSend.valuesToSend[5] = (int)blue(c);
    arduinoSend.sendValues();
  }
  void setZone2Colour(color c) {
    ledColour[1] = c;    
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[6] = (int)red(c);
    arduinoSend.valuesToSend[7] = (int)green(c);
    arduinoSend.valuesToSend[8] = (int)blue(c);
    arduinoSend.sendValues();
  }
  void setZone3Colour(color c) {
    ledColour[2] = c;
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[9] = (int)red(c);
    arduinoSend.valuesToSend[10] = (int)green(c);
    arduinoSend.valuesToSend[11] = (int)blue(c);
    arduinoSend.sendValues();
  }
  void setZone4Colour(color c) {
    ledColour[3] = c;
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[12] = (int)red(c);
    arduinoSend.valuesToSend[13] = (int)green(c);
    arduinoSend.valuesToSend[14] = (int)blue(c);
    arduinoSend.sendValues();
  }
  void setZone5Colour(color c) {
    ledColour[4] = c;
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[15] = (int)red(c);
    arduinoSend.valuesToSend[16] = (int)green(c);
    arduinoSend.valuesToSend[17] = (int)blue(c);
    arduinoSend.sendValues();
  }
  void setZone6Colour(color c) {
    ledColour[5] = c;
    arduinoSend.valuesToSend[2] = LED;
    arduinoSend.valuesToSend[18] = (int)red(c);
    arduinoSend.valuesToSend[19] = (int)green(c);
    arduinoSend.valuesToSend[20] = (int)blue(c);
    arduinoSend.sendValues();
  }

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

    //draw gun
    if (frameCount % 5 == 0) {
      image(gun, (width/1.2)-120, height/2, 240, 150);
    }

    //draw chocolate
    if (frameCount % 5 == 0) {
      // image(chocolate, 50, height/2, 240, 150);
    }
  }

  void mousePressed()
  {
  }


  void keyPressed()
  { 
    if ( key == 'q' || key == ESC )
      abortTest();
  }
}