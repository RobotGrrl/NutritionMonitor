// -- ARDUINO -- //
Serial arduino;
int port = 99;
boolean connected = false;

// -- PARSING -- //
int msgLen = 12;
int msgIndex = 0;
char[] msg = new char[msgLen];
boolean reading = false;
boolean completed = false;
int receivedValue = 0;

// -- RECEIVE -- //
static String module1 = "M1";
static String module2 = "M2";
static String module3 = "M3";


void readData() {
 
  if(connected) {
  
    // let's read the data
    
    char m;
    
    while(arduino.available() > 0) {
      
      m = arduino.readChar();
     
      if(m == '!') {
        if(DEBUG) println("\nping");
        reading = true;
      }
      
      if(DEBUG) print(m + " ");
      
      if(reading) {
        if(msgIndex < msgLen) msg[msgIndex++] = m;
      }
      
      if(m == '~') {
        if(DEBUG) println("\nding");
        reading = false;
        completed = true;
      }
      
    }
    
    if(completed) {
      if(DEBUG) println("\ngood job");
      
      for(int i=0; i<msgIndex; i++) {
        if(DEBUG) print(msg[i] + " "); 
      }
      if(DEBUG) print("\n");
      
      String cmd = "";
      if(msg[0] == '!') {
        cmd += ("" + msg[1] + "" + msg[2]);
      }
      if(DEBUG) println("cmd: " + cmd);
      
      String val = "";
      if(msg[3] == ':') {
        
        for(int i=4; i<(msgIndex-1); i++) {
          val += msg[i];
        }
        
      }
      if(DEBUG) println("val: " + val);
      
      boolean good = false;
      if(msg[(msgIndex-1)] == '~') {
        good = true;
      }
      
      if(good) {
        if(DEBUG) println("good!");
          parseCommand(cmd, val);
      }
      
      msgIndex = 0;
      completed = false;
      
    }
    
  }
  
}


void parseCommand(String cmd, String val) {
 
 if(cmd.equals(module1)) {
    if(val != "" && val.length() < 5) receivedValue = (int)Integer.parseInt(val);
    updateCurrentVal(0, receivedValue);
  } else if(cmd.equals(module2)) {
    if(val != "" && val.length() < 5) receivedValue = (int)Integer.parseInt(val);
    updateCurrentVal(1, receivedValue);
  } else if(cmd.equals(module3)) {
    if(val != "" && val.length() < 5) receivedValue = (int)Integer.parseInt(val);
    updateCurrentVal(2, receivedValue);
  }
  
}


void sendSerial(String sl, int val) {
  arduino.write("!" + sl + ":" + val + "~");
  if(DEBUG) print(">");
}

