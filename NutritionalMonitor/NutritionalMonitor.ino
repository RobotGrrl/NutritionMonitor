/*
 * Nutritional Monitor
 * -------------------
 *
 * Using the NutriModule library, monitor force sensitive resistors 
 * on multiple food modules.
 * Report any changes of the data through serial to an application.
 * 
 * LIVE dashboard view at:
 * http://robotgrrl.com/nutritionmonitor/
 * 
 * This sketch requires the NutriModule library installed
 * As well as the Streaming library installed
 * 
 * For more information:
 * http://robotgrrl.com/blog
 *
 * By Erin RobotGrrl, Feb 3, 2014
 *
 * License: CC BY-SA
 */

#include <NutriModule.h>
#include <Streaming.h>

#define MODULE1_BUTTON_PIN 2
#define MODULE1_LED_PIN 3
#define MODULE1_NUM_SENS 1
#define MODULE1_SENS1_PIN A0
#define MODULE1_SENS2_PIN A1
#define MODULE1_SENS3_PIN A2

#define MODULE2_BUTTON_PIN 4
#define MODULE2_LED_PIN 5
#define MODULE2_NUM_SENS 1
#define MODULE2_SENS1_PIN A3

#define MODULE3_BUTTON_PIN 7
#define MODULE3_LED_PIN 6
#define MODULE3_NUM_SENS 2
#define MODULE3_SENS1_PIN A4
#define MODULE3_SENS2_PIN A5

NutriModule module1(1, MODULE1_LED_PIN, MODULE1_BUTTON_PIN);
NutriModule module2(2, MODULE2_LED_PIN, MODULE2_BUTTON_PIN);
NutriModule module3(3, MODULE3_LED_PIN, MODULE3_BUTTON_PIN);

void setup() {
  Serial.begin(9600);  
  
  module1.setSensNum(MODULE1_NUM_SENS);
  //module1.setSensPins(MODULE1_SENS1_PIN, MODULE1_SENS2_PIN, MODULE1_SENS3_PIN, 0);
  module1.setSensPins(MODULE1_SENS2_PIN, 0, 0, 0);
  
  module2.setSensNum(MODULE2_NUM_SENS);
  module2.setSensPins(MODULE2_SENS1_PIN, 0, 0, 0);
  
  module3.setSensNum(MODULE3_NUM_SENS);
  module3.setSensPins(MODULE3_SENS1_PIN, MODULE3_SENS2_PIN, 0, 0);
  
  //setWeightDefaultTest();
  
}

int count = 0;

void loop() {
  
  module1.update();
  module2.update();
  module3.update();
  
  //delay(10);
  
  //cereal.testFunc();
  //delay(100);
  //Serial << "\t" << cereal.measuredWeight() << "\t\t\t 1: " << cereal.getRawSens(0) << " 2: " << cereal.getRawSens(1) << " 3: " << cereal.getRawSens(2) << endl;
  
//  if(cereal.buttonPressed()) {
//    count++;
//    Serial << endl << count << endl;
//  }
  
  //Serial << "~";
  
  //delay(100);
  
}

