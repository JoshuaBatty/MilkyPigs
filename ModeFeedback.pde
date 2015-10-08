class ModeFeedback extends Mode
{
  PImage pig = loadImage("pig_feeding.jpg"); 
  PImage gun = loadImage("gun.jpg"); 
  PImage chocolate = loadImage("maltesers.jpg"); 

  color ledColour = color(255,100,0);
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
  
  void setLedColour(color c){
    ledColour = c;
    println("R = ", red(ledColour));
  }

  void draw()
  {
    background( 255 );
    pushStyle();
    fill( ledColour );
    for (int i = 0; i < 52; i++) {
      rect(17+(18*i)+33, 150, 9, 9);
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