import processing.serial.*;
Serial arduinoPort;  // Create object from Serial class

class Arduino {

  int[] valuesToSend = {M, P, 0, 0, 0, 0, 0, 0};
  byte out[] = new byte[8];

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