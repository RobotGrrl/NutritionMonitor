/*****************************
  Library for the Nutritional Monitor Modules

  Able to measure pressure amount from DIY force-sensitive resistors,
  filter the data, and work through a state machine.

  For more information:
  http://robotgrrl.com/blog

  By Erin RobotGrrl - Feb. 3, 2014

  License: CC BY-SA
******************************/

#ifndef NutriModule_H
#define NutriModule_H

#if ARDUINO >= 100
 #include "Arduino.h"
#else
 #include "WProgram.h"
#endif

#define LOG_DEBUG false

#define INIT_STATE 0
#define SCAN_STATE 1
#define WAIT_STATE 2

#define SENS_AVG_LEN 200

class NutriModule {
	
  public:
  	NutriModule(uint8_t modNum, uint8_t ledPin, uint8_t buttonPin); // module number, led pin, button pin

  	// Accessors & setters
 	  void setSensNum(uint8_t num);
  	void setSensPins(uint8_t pinA, uint8_t pinB, uint8_t pinC, uint8_t pinD);
  	uint16_t measuredWeight();
  	bool buttonPressed();
  	uint16_t getRawSens(uint8_t num);
  	void setWeightDefault(uint16_t num);

  	// Misc
  	void testFunc();

  	// State machine
  	void update();
  	
  	// Input Output
  	void blink(uint8_t rep, uint8_t del);
  	void ledOn();
	  void ledOff();

	  // WEIGHT
	  uint16_t WEIGHT_NONE;
  	uint16_t WEIGHT_EMPTY;
  	uint16_t WEIGHT_FULL;


  private:

  	// MODULE
  	uint8_t MODULE_NUM;

  	// WEIGHT
  	uint16_t WEIGHT_VALS[3];
  	uint16_t WEIGHT_STABLE;
  	uint16_t WEIGHT_CUR;
  	uint16_t WEIGHT_PREV;

  	// INIT
  	uint8_t CURRENT_STATE;
  	uint8_t INIT_BUTTON_COUNT;
  	
  	// MISC
  	uint16_t THRESH_NONE;
  	uint16_t THRESH_STABLE;
  	uint8_t PRESSES;
    long PREV_BUTTON;
    long LAST_BLINK;
    uint8_t BLINK_COUNT;
    bool WAIT_FOR_BUTTON;
    long START_WAIT_TIME;

  	// PINS
  	uint8_t LED_PIN;
  	uint8_t BUTTON_PIN;
  	uint8_t SENS_PINS[4];

  	// SENS
  	uint8_t SENS_NUM;
  	uint16_t SENS_VALS[4];
  	uint16_t SENS_AVG[4];
  	uint16_t SENS_AVG_COUNT;
  	uint16_t SENS_RES[4];


	// State machine  	
  	void initState();
  	void scanState();
  	void waitState();

  	// Update
  	void updateSensors();
  	void updateData();


};

#endif
