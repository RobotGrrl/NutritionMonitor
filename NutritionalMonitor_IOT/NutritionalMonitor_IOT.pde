/*
 * Nutritional Monitor
 * -------------------
 * 
 * Calculates malnutrition score from weight sensor data.
 * Uploads data to the 'Internet of Things' using ThingSpeak.
 * Tweets when malnutrition score exceeds a threshold.
 * 
 * LIVE dashboard view at:
 * http://robotgrrl.com/nutritionmonitor/
 * 
 * You can set your own mass (in pounds) and height (in inches)
 * with the variables below. This is used to calculate your
 * BMI for an initial value of the MUST score.
 *
 * Replace APIKEY and THINGTWEET_KEY with your own keys from
 * ThingSpeak.com. MUST_THRESH is the threshold (>=) for
 * tweeting about the alert.
 * 
 * For more information:
 * http://robotgrrl.com/blog
 *
 * By Erin RobotGrrl, Feb. 5, 2014
 * 
 * License: CC BY-SA
 */

import controlP5.*;
import processing.serial.*;
import processing.net.*;

static final boolean DEBUG = true;
static final boolean SIMULATE = true;

String SERVER = "api.thingspeak.com";
String APIKEY = "";
String THINGTWEET_KEY = "";
int FREQ = 15;

float MASS_LB = 100;
float HEIGHT_IN = 60;
float MUST_THRESH = 1.8;


void setup() {
  size(450, 500);
  noStroke();

  initControlP5();  
  initNutrition();
  
  if(SIMULATE) initSimulation();
  
}

void draw() {
  
  background(0);
  
  if(guiVisible) {
    cp5.draw();
    cp5_v2.draw();
    updateGUILabels();
  }
  
  readData();
  updateThingSpeak();
  
}

void keyPressed() {
    switch(key) {
    case 'h':
      guiVisible = !guiVisible;
      break;
    case 'p':
      printModCurrent();
      break;
    case 'd':
      printDayVals();
      break;
    }
    //println(frameRate);
}


