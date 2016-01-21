import processing.serial.*;
Serial arduinoPort;  // Create object from Serial class
PApplet pApplet;

class Arduino {

  int[] valuesToSend = {M, P, 0, 0, 0, 0, 0, 0};
  byte out[] = new byte[8];

  int index;                          //The dropdown list will return a float value, which we will connvert into an int. we will use this int for that).
  String[] comList;                //A string to hold the ports in.
  boolean serialSet = false;       //A value to test if we have setup the Serial port.
  boolean Comselected = false;     //A value to test if you have chosen a port in the list.

  Arduino(PApplet papp) {
    pApplet = papp;
    /*
    // Setup serial connection
    println(Serial.list());
    // This is going to need to be changed for the device that they are using. 
    String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
    arduinoPort = new Serial(papp, portName, 9600);
    arduinoPort.bufferUntil('\n');
    */
  }

  //---------------------------------------------
  void sendValues() {
    if (serialSet == true) {
      out = byte(valuesToSend);  
      arduinoPort.write(out);
      delay(100);
    }
  }

  //---------------------------------------------
  void update() {
    //So when we have chosen a Serial port but we havent yet setup the Serial connection. Do this loop
    while (Comselected == true && serialSet == false) {
      //Call the startSerial function, sending it the char array (string[]) comList
      startSerial(comList);
    }
  }

  //---------------------------------------------
  void startSerial(String[] thePort)
  {
    //When this function is called, we setup the Serial connection with the accuried values. The int index acesses the determins where to accsess the char array. 
    arduinoPort = new Serial(pApplet, thePort[index], 9600);
    arduinoPort.bufferUntil('\n');

    //Since this is a one time setup, we state that we now have set up the connection.
    serialSet = true;

    println("Serial Port " + thePort[index] + " is now connected :)");
  }

  //here we setup the dropdown list.
  //----------------------------------------------------------------------
  void customize(DropdownList ddl) {
    //Set the background color of the list (you wont see this though).
    ddl.setBackgroundColor(color(200));
    //Set the height of each item when the list is opened.
    ddl.setItemHeight(30);
    //Set the height of the bar itself.
    ddl.setBarHeight(30);
    //Set the lable of the bar when nothing is selected.
    ddl.getCaptionLabel().set("Select COM port");
    //Set the top margin of the lable.
    ddl.getCaptionLabel().getStyle().setMarginTop(3);
    //Set the left margin of the lable.
    ddl.getCaptionLabel().getStyle().setMarginLeft(3);
    //Set the top margin of the value selected.
    ddl.getValueLabel().getStyle().setMarginTop(3);
    //Store the Serial ports in the string comList (char array).
    comList = arduinoPort.list();
    //We need to know how many ports there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
    String comlist = join(comList, ",");
    //We also need how many characters there is in a single port name, we´ll store the chars here for counting later.
    String COMlist = comList[0];
    //Here we count the length of each port name.
    int size2 = COMlist.length();
    //Now we can count how many ports there are, well that is count how many chars there are, so we will divide by the amount of chars per port name.
    int size1 = comlist.length() / size2;
    //Now well add the ports to the list, we use a for loop for that. How many items is determined by the value of size1.
    for (int i=0; i< size1; i++)
    {
      //This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
      ddl.addItem(comList[i], i);
    }
    //Set the color of the background of the items and the bar.
    ddl.setColorBackground(color(60));
    //Set the color of the item your mouse is hovering over.
    ddl.setColorActive(color(255, 128));
  }
}