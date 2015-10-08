class ModeTest extends Mode
{
  ModeTest() {
    int padding = 100;
    int buttonWidth = 180;

    cp5.addTab("default")
      .setLabel("test")
      .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
      .setColorActive(color(255, 128, 0))
      .activateEvent(true)
      .setId(0)
      ;

    // create a new button with name 'buttonA'
    cp5.addButton("Test1")
      .setValue(0)
      .setPosition((width/2)-padding, 100)
      .setSize(200, 39)
      ;

    // and add another 2 buttons
    cp5.addButton("Test2")
      .setValue(0)
      .setPosition((width/2)-padding, 142)
      .setSize(200, 39)
      ;

    cp5.addButton("Test3")
      .setPosition((width/2)-padding, 184)
      .setSize(200, 39)
      .setValue(0)
      ;


    cp5.addToggle("LeftPad")
      .setBroadcast(false)
      .setPosition(width/3-(buttonWidth/2)-padding, height/2-100)
      .setSize(buttonWidth, 140)
      .setValue(0)
      .setBroadcast(true)
      .getCaptionLabel().align(CENTER, CENTER)
      ;

    cp5.addToggle("MiddlePad")
      .setBroadcast(false)
      .setPosition(width/2-(buttonWidth/2), height/2-100)
      .setSize(buttonWidth, 140)
      .setValue(0)
      .setBroadcast(true)
      .getCaptionLabel().align(CENTER, CENTER)
      ;

    cp5.addToggle("RightPad")
      .setBroadcast(false)
      .setPosition(width/1.5-(buttonWidth/2)+padding, height/2-100)
      .setSize(buttonWidth, 140)
      .setValue(0)
      .setBroadcast(true)
      .getCaptionLabel().align(CENTER, CENTER)
      ;

    PImage[] imgs = {loadImage("StartTestButton_off.jpg"), loadImage("StartTestButton_over.jpg"), loadImage("StartTestButton_clicked.jpg")};
    cp5.addButton("StartTest")
      .setValue(0)
      .setPosition((width/2)-(280/2), height/2+150)
      .setImages(imgs)
      .setBroadcast(true)
      .updateSize()
      .activateBy(cp5.RELEASE)
      ;

    cp5.getController("Test1").moveTo("default");
    cp5.getController("Test2").moveTo("default");
    cp5.getController("Test3").moveTo("default");

    cp5.getController("LeftPad").moveTo("default");
    cp5.getController("MiddlePad").moveTo("default");
    cp5.getController("RightPad").moveTo("default");

    cp5.getController("StartTest").moveTo("default");
  }

  void setup() {
  }

  void setTestMode(int testMode) {
    if (testMode == 0) {
      cp5.getController("LeftPad").setValue(0);  
      cp5.getController("MiddlePad").setValue(0);  
      cp5.getController("RightPad").setValue(0);
      arduinoSend.valuesToSend[3] = 0;
      arduinoSend.valuesToSend[4] = 0;
      arduinoSend.valuesToSend[5] = 0;
    } else if (testMode == 1) {
      cp5.getController("LeftPad").setValue(1);  
      cp5.getController("MiddlePad").setValue(0);  
      cp5.getController("RightPad").setValue(1);
      arduinoSend.valuesToSend[3] = 1;
      arduinoSend.valuesToSend[4] = 0;
      arduinoSend.valuesToSend[5] = 1;
    } else if (testMode == 2) {
      cp5.getController("LeftPad").setValue(0);  
      cp5.getController("MiddlePad").setValue(1);  
      cp5.getController("RightPad").setValue(0);
      arduinoSend.valuesToSend[3] = 0;
      arduinoSend.valuesToSend[4] = 1;
      arduinoSend.valuesToSend[5] = 0;
    } else if (testMode == 3) {
      cp5.getController("LeftPad").setValue(1);  
      cp5.getController("MiddlePad").setValue(1);  
      cp5.getController("RightPad").setValue(1);
      arduinoSend.valuesToSend[3] = 1;
      arduinoSend.valuesToSend[4] = 1;
      arduinoSend.valuesToSend[5] = 1;
    }
  }

  void draw()
  {
    pushStyle();	
    background( 255 );
    stroke( 0 );
    text("PAUSE MODE\n press space to continue", width/2, height/2);
    popStyle();
  }


  void mousePressed() {
  }


  void keyPressed()
  {
    //change state
    //--------------		
    if ( key == ' ' )
      mode = START;


    if ( key == 'q' || key == ESC )
      abortTest();
  }
}