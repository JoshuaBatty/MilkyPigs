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
    println("R = ", red(ledColour[0]));
    println("FUCK");
  }

  void draw()
  {
    background( 255 );
    pushStyle();
    /*
    for (int i = 0; i < 54; i++) {
     //fill( ledColour[i] );
     rect(17+(18*i)+33, 320, 9, 9);
     }
     */
     int count = 0;
    for (int j = 0; j < 6; j++) {
      for (int i = 0; i < 9; i++) {
        fill( ledColour[j] );
        rect(17+(18*count)+33, 320, 9, 9);
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