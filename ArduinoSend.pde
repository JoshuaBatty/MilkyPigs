import processing.serial.*;
Serial arduinoPort;  // Create object from Serial class

static final int M = 77;
static final int P = 80;

class ArduinoSend {

  int[] valuesToSend = {M, P, 0, 0, 0, 0, 0};
  byte out[] = new byte[7];

  ArduinoSend(PApplet papp) {
    // Setup serial connection
    String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
    arduinoPort = new Serial(papp, portName, 9600);
  }

  void sendValues() {
    out = byte(valuesToSend);  
    arduinoPort.write(out);
  }
}


// I think I should be able to maybe just rename this to 'Arduino' and have it send and receive values!