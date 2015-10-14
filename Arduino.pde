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
    delay(100);
  }
}