// -- GUI -- //
ControlP5 cp5;
ControlP5 cp5_v2;
DropdownList d1;
boolean guiVisible = true;

Textlabel mod1Label;
Textlabel mod2Label;
Textlabel mod3Label;

Textlabel portion1Label;
Textlabel portion2Label;
Textlabel portion3Label;

Textlabel mustLabel;


void initControlP5() {
  cp5 = new ControlP5(this);
  cp5_v2 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5_v2.setAutoDraw(false);
  cp5.setMoveable(false);
  cp5_v2.setMoveable(false);
  
  loadGui();
  
  for (int i=0; i<Serial.list().length; i++) {
    if(DEBUG) println(Serial.list()[i]);
    d1.addItem("" + Serial.list()[i], i);
  }
  
  frame.setBackground(new java.awt.Color(0,0,0));
  
}


void loadGui() {
 
  Group g0 = cp5.addGroup("g0")
                .setPosition(25,20)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("Connection")
                .disableCollapse()
                ;
  
   d1 = cp5_v2.addDropdownList("serialports")
          .setPosition(45, 65)
          .setSize(200,300)
          .setBarHeight(30)
          .setCaptionLabel("Serial Ports")
          ;
          
  customize(d1);
  
  cp5.addButton("connect")
     .setValue(0)
     .setPosition(280,15)
     .setSize(100,30)
     .setGroup(g0)
     .setCaptionLabel("Connect!")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
  
  
  
  Group g1 = cp5.addGroup("g1")
                .setPosition(25,100)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("Simulate")
                .disableCollapse()
                ;
                
  cp5.addButton("mod1_sim")
     .setValue(0)
     .setPosition(20,15)
     .setSize(100,30)
     .setGroup(g1)
     .setCaptionLabel("Module 1")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
     
  cp5.addButton("mod2_sim")
     .setValue(0)
     .setPosition(150,15)
     .setSize(100,30)
     .setGroup(g1)
     .setCaptionLabel("Module 2")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
     
  cp5.addButton("mod3_sim")
     .setValue(0)
     .setPosition(280,15)
     .setSize(100,30)
     .setGroup(g1)
     .setCaptionLabel("Module 3")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
  
  
  Group g2 = cp5.addGroup("g2")
                .setPosition(25,180)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("Control")
                .disableCollapse()
                ;
  
  cp5.addButton("nextday")
     .setValue(0)
     .setPosition(20,15)
     .setSize(100,30)
     .setGroup(g2)
     .setCaptionLabel("Next day")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
     
  cp5.addButton("refillfood")
     .setValue(0)
     .setPosition(150,15)
     .setSize(100,30)
     .setGroup(g2)
     .setCaptionLabel("Refill Food")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
  
  
  Group g3 = cp5.addGroup("g3")
                .setPosition(25,260)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("Current Food Levels")
                .disableCollapse()
                ;
  
  PFont textfieldFont = createFont("arial",25);

  mod1Label = cp5.addTextlabel("mod1")
     .setText("mod1")
     .setPosition(20,10)
     .setGroup(g3)
     .setFont(textfieldFont)
     ;
     
  mod2Label = cp5.addTextlabel("mod2")
     .setText("mod1")
     .setPosition(150,10)
     .setGroup(g3)
     .setFont(textfieldFont)
     ;
     
  mod3Label = cp5.addTextlabel("mod3")
     .setText("mod1")
     .setPosition(280,10)
     .setGroup(g3)
     .setFont(textfieldFont)
     ;
  
  
  Group g4 = cp5.addGroup("g4")
                .setPosition(25,340)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("Daily Portion Remaining")
                .disableCollapse()
                ;

  portion1Label = cp5.addTextlabel("portion1")
     .setText("mod1")
     .setPosition(20,10)
     .setGroup(g4)
     .setFont(textfieldFont)
     ;
     
  portion2Label = cp5.addTextlabel("portion2")
     .setText("mod1")
     .setPosition(150,10)
     .setGroup(g4)
     .setFont(textfieldFont)
     ;
     
  portion3Label = cp5.addTextlabel("portion3")
     .setText("mod1")
     .setPosition(280,10)
     .setGroup(g4)
     .setFont(textfieldFont)
     ;
  
  
  
  Group g5 = cp5.addGroup("g5")
                .setPosition(25,420)
                .setWidth(width-25*2)
                .setHeight(10)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("M.U.S.T. Score")
                .disableCollapse()
                ;

  mustLabel = cp5.addTextlabel("mustlabel")
     .setText("mod1")
     .setPosition(20,10)
     .setGroup(g5)
     .setFont(textfieldFont)
     ;
     
  
}


void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  //ddl.setBarHeight(15);
  ddl.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  //ddl.captionLabel().style().marginTop = 3;
  //ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
}


void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    
    if(theEvent.getGroup().getName().equals("serialports")) {
      port = (int)theEvent.getGroup().getValue();
      println("selected port: " + port);
    }
    
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}


void updateGUILabels() {

  mod1Label.setText(MODULE_CURRENT[0] + "%");
  mod2Label.setText(MODULE_CURRENT[1] + "%");
  mod3Label.setText(MODULE_CURRENT[2] + "%");
  
  portion1Label.setText(MODULE_PORTION_REMAINING[0] + "%");
  portion2Label.setText(MODULE_PORTION_REMAINING[1] + "%");
  portion3Label.setText(MODULE_PORTION_REMAINING[2] + "%");
  
  String s = "";
  int temp = (int)MUST_TOTAL_SCORE;
  
  if(temp < 2) {
    s = "Routine nutrition";
  } else if(temp == 2) {
    s = "Observe nutrition";
  } else if(temp > 2) {
    s = "Treat nutrition";
  }
  
  mustLabel.setText(String.format("%.2f", MUST_TOTAL_SCORE) + ": " + s);
  
}


/*
 * Buttons
 */

void connect(int theValue) {
  
  if(!connected) {
  
  if(port != 99) {
    println("connected");
    connected = true;
    arduino = new Serial(this, Serial.list()[port], 9600);
    cp5.getController("connect").setCaptionLabel("Disconnect");
  } else {
   println("need to select a port!"); 
  }
  
  } else {
    
    arduino.clear();
    arduino.stop();
    
    cp5.getController("connect").setCaptionLabel("Connect!");
    //port = 99;
    connected = false;
    
  }
  
}

void nextday(int theValue) {
  incrementDay();
}

void refillfood(int theValue) {
  for(int i=0; i<3; i++) {
    MODULE_CURRENT[i] = 100;
  }
}

void mod1_sim(int theValue) {
  simulateModule(0);
}

void mod2_sim(int theValue) {
  simulateModule(1);
}

void mod3_sim(int theValue) {
  simulateModule(2);
}


