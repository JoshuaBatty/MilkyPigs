import processing.serial.*;
Serial arduinoPort;  // Create object from Serial class

static final int M = 77;
static final int P = 80;

static final int STOP = 0;
static final int RUN = 1;
static final int FEEDBACK = 2;
static final int SETTINGS = 3;
static final int SELF_TEST = 4;
static final int SET_COLOURS = 5;

class Arduino {

  int[] valuesToSend = {M, P, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  byte out[] = new byte[21];

  Arduino(PApplet papp) {
    // Setup serial connection
    println(Serial.list());
    String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
    arduinoPort = new Serial(papp, portName, 9600);
    arduinoPort.bufferUntil('\n');
  }

  //---------------------------------------------
  void sendValues() {
    out = byte(valuesToSend);  
    arduinoPort.write(out);
  }

  // Each time we see a carriage return this method gets called. 
  //---------------------------------------------
  void serialEvent( Serial arduinoPort) {
    String serial = "";

    while (arduinoPort.available () > 0) { //as long as there is data coming from serial port, read it and store it
      serial = arduinoPort.readStringUntil(10);
    }  
    if (serial != null) { // if the string is not empty, print the following
      String[] a = split(serial, ','); // a new array (called 'a') that stores values into seperate cells (seperated by commas specified in your Arduino program)

      if (a[0] == "MP") {
        currentTestResult.state = a[1];
        currentTestResult.buttonPressed = a[2];
        currentTestResult.testDuration = a[3];

        println(a[0]); // This should be MP
        println("state = " + currentTestResult.state);
        println("buttonPressed = " + currentTestResult.buttonPressed);
        println("testDuration = " + currentTestResult.testDuration);
      }
    }
  }
}