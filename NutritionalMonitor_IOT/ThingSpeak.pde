int sec_0 = 88;
int sec;
String[] FIELDS = { 
  "field1", "field2", "field3", "field4", "field5", "field6", "field7"
};
float[] DATUM = new float[7];

Client c;
String data;

static final boolean ARDUINO_DEMO = true;
int count = 0;

void updateThingSpeak() {
 
 if (c != null) {
    if (c.available() > 0) {
      data = c.readString();
      println("entry_id: " + data + "\n");
    }
  }

  sec = second();

  if (sec%FREQ == 0 && sec_0 != sec) {
    println("\n\nding!");
    sec_0 = sec;
    //sendData("field1", 3);
    
    if(SIMULATE) tickSimulation();
    
    loadDatum();
    sendDatum(FIELDS, DATUM);
    
    if(ARDUINO_DEMO) {
      if(count%4 == 0) {
        incrementDay();
      }
      count++;
    }
    
    println("done");
  } 
  else {
    if (sec != sec_0) {
      print(sec + " ");
      sec_0 = sec;
    }
  }
  
}


void sendData(String field, float num) {

  String url = ("GET /update?key="+APIKEY+"&"+field+"=" + num + "\n");
  print("sending data: " + url);

  c = new Client(this, SERVER, 80);
  if (c != null) c.write(url);
}


void sendDatum(String fields[], float num[]) {

  String url = ("GET /update?key="+APIKEY);
  StringBuffer sb = new StringBuffer(url);

  for (int i=0; i<fields.length; i++) {
    String s = ("&"+fields[i]+"="+DATUM[i]);
    sb.append(s);
  }

  sb.append("\n");

  String finalurl = sb.toString();
  print("sending data: " + finalurl);

  c = new Client(this, SERVER, 80);
  if (c != null) c.write(finalurl);
}


void sendTweet(String msg) {
  
  println("sending tweet");
  
  String url = ("GET /apps/thingtweet/1/statuses/update?api_key=" + THINGTWEET_KEY + "&status=" + msg);
  StringBuffer sb = new StringBuffer(url);

  sb.append("\n");

  String finalurl = sb.toString();
  print("sending data: " + finalurl);

  c = new Client(this, SERVER, 80);
  if (c != null) c.write(finalurl);
  
  println("sent");
   
}


void loadDatum() {

  DATUM[0] = MODULE_CURRENT[0];  
  DATUM[1] = MODULE_CURRENT[1];
  DATUM[2] = MODULE_CURRENT[2];
  
  DATUM[3] = MODULE_PORTION_REMAINING[0];
  DATUM[4] = MODULE_PORTION_REMAINING[1];
  DATUM[5] = MODULE_PORTION_REMAINING[2];
  
  DATUM[6] = MUST_TOTAL_SCORE;
  
}

