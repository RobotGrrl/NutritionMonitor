/*****************************
  Library for the Nutritional Monitor Modules

  Able to measure pressure amount from DIY force-sensitive resistors,
  filter the data, and work through a state machine.

  For more information:
  http://robotgrrl.com/blog

  By Erin RobotGrrl - Feb. 3, 2014

  License: CC BY-SA
******************************/

#include <NutriModule.h>
#include <Streaming.h>

NutriModule::NutriModule(uint8_t modNum, uint8_t ledPin, uint8_t buttonPin) {
	THRESH_NONE = 10;
	THRESH_STABLE = 5;

	PREV_BUTTON = 0;
	INIT_BUTTON_COUNT = 0;
	LAST_BLINK = 0;
	BLINK_COUNT = 0;
	WAIT_FOR_BUTTON = false;
	START_WAIT_TIME = 0;

	MODULE_NUM = modNum;
	LED_PIN = ledPin;
	BUTTON_PIN = buttonPin;

	pinMode(LED_PIN, OUTPUT);
	pinMode(BUTTON_PIN, INPUT);

	CURRENT_STATE = INIT_STATE;
	if(LOG_DEBUG) Serial.println("starting init state");
}

void NutriModule::setSensNum(uint8_t num) {
	SENS_NUM = num;

	for(int i=0; i<SENS_NUM; i++) {
		pinMode(SENS_PINS[i], INPUT);
	}
}

void NutriModule::setSensPins(uint8_t pinA, uint8_t pinB, uint8_t pinC, uint8_t pinD) {
	SENS_PINS[0] = pinA;
	SENS_PINS[1] = pinB;
	SENS_PINS[2] = pinC;
	SENS_PINS[3] = pinD;
}

uint16_t NutriModule::measuredWeight() {
  return WEIGHT_CUR;
}

bool NutriModule::buttonPressed() {
	if(digitalRead(BUTTON_PIN) == HIGH && millis()-PREV_BUTTON >= 300) {
		PREV_BUTTON = millis();
		return true;
	}
	return false;
}

uint16_t NutriModule::getRawSens(uint8_t num) {
	if(num < SENS_NUM) {
		return analogRead(SENS_PINS[num]);
	}
	return 0;
}

void NutriModule::setWeightDefault(uint16_t num) {
	WEIGHT_VALS[INIT_BUTTON_COUNT] = num;
	INIT_BUTTON_COUNT++;

	if(LOG_DEBUG) Serial.print("set weight: ");
	if(LOG_DEBUG) Serial.println(num);

	if(INIT_BUTTON_COUNT >= 2) {

		uint8_t SMALLEST_IND = 0;
  	 	uint8_t MIDDLE_IND = 0;
  		uint8_t LARGEST_IND = 0;
		
		for(int i=0; i<2; i++) {
			if(WEIGHT_VALS[i] < WEIGHT_VALS[SMALLEST_IND]) {
				SMALLEST_IND = i;
			}
		}
		//WEIGHT_NONE = WEIGHT_VALS[SMALLEST_IND];
		WEIGHT_NONE = 0;
		WEIGHT_EMPTY = 0;

		for(int i=0; i<2; i++) {
			if(WEIGHT_VALS[i] > WEIGHT_VALS[LARGEST_IND]) {
				LARGEST_IND = i;
			}
		}
		WEIGHT_FULL = WEIGHT_VALS[LARGEST_IND];
		/*
		if(SMALLEST_IND == 0) {
			if(LARGEST_IND == 1) {
				MIDDLE_IND = 2;
			} else {
				MIDDLE_IND = 1;
			}
		} else if(SMALLEST_IND == 1) {
			if(LARGEST_IND == 0) {
				MIDDLE_IND = 2;
			} else {
				MIDDLE_IND = 0;
			}
		} else if(SMALLEST_IND == 2) {
			if(LARGEST_IND == 0) {
				MIDDLE_IND = 1;
			} else {
				MIDDLE_IND = 0;
			}
		}
		WEIGHT_EMPTY = WEIGHT_VALS[MIDDLE_IND];
		*/
	}

}


/*
 * MISC
 */ 

void NutriModule::testFunc() {

	//update();


	/*
	// scan state
	
	*/

	// wait state
	

}


/*
 * STATE MACHINE
 */

void NutriModule::update() {

	switch(CURRENT_STATE) {
		case INIT_STATE:
			initState();
		break;
		case SCAN_STATE:
			scanState();
		break;
		case WAIT_STATE:
			waitState();
		break;
	}

}

void NutriModule::initState() {

	ledOff();
	updateSensors();

	if(buttonPressed()) {
		setWeightDefault(measuredWeight());
		blink(2, 100);
		if(LOG_DEBUG) Serial.print("button count: ");
		if(LOG_DEBUG) Serial.println(INIT_BUTTON_COUNT);
	}

	if(INIT_BUTTON_COUNT >= 2) {
		ledOn();
		INIT_BUTTON_COUNT = 0;
		CURRENT_STATE = SCAN_STATE;
		if(LOG_DEBUG) Serial.println("starting scan state");
	}

}

void NutriModule::scanState() {

	ledOn();
	updateSensors();

	if(measuredWeight() >= 0 && measuredWeight() <= WEIGHT_EMPTY) { // 5 could represent empty
	//if(measuredWeight() >= WEIGHT_NONE && measuredWeight() <= WEIGHT_EMPTY) { // 5 could represent empty
		if(LOG_DEBUG) Serial << "lifted!" << endl;
		//if(!WAIT_FOR_BUTTON) START_WAIT_TIME = millis();
		//WAIT_FOR_BUTTON = true;
		//ledOff();
	}

	//if(WAIT_FOR_BUTTON == true && buttonPressed() == true) {
	if(buttonPressed() == true) {
		if(LOG_DEBUG) Serial << "pressed!" << endl;
		WAIT_FOR_BUTTON = false;
		CURRENT_STATE = WAIT_STATE;
	}

	/*
	if(WAIT_FOR_BUTTON == true && millis()-START_WAIT_TIME >= 5000) {
		WAIT_FOR_BUTTON = false;
		if(LOG_DEBUG) Serial << "false alarm" << endl;
	}
	*/

}

void NutriModule::waitState() {

	updateSensors();

	if(measuredWeight() > WEIGHT_EMPTY && measuredWeight() <= (WEIGHT_FULL+THRESH_STABLE)) { // 3 represents empty with some wiggle room
		if(LOG_DEBUG) Serial << "back!" << endl;
		//if(!WAIT_FOR_BUTTON) START_WAIT_TIME = millis();
		//WAIT_FOR_BUTTON = true;
		ledOff();
	} else {
		blink(1, 100);

		/*
		if(buttonPressed()) {
			PRESSES++;
			if(PRESSES >= 3) {
				PRESSES = 0;
				CURRENT_STATE = INIT_STATE;
			}
		}
		*/
	}

	//if(WAIT_FOR_BUTTON == true && buttonPressed() == true) {
	if(buttonPressed() == true) {
		if(LOG_DEBUG) Serial << "pressed!" << endl; 
		updateData();
		CURRENT_STATE = SCAN_STATE;
		WAIT_FOR_BUTTON = false;
	}

	/*
	if(WAIT_FOR_BUTTON == true && millis()-START_WAIT_TIME >= 5000) {
		WAIT_FOR_BUTTON = false;
		if(LOG_DEBUG) Serial << "false alarm" << endl;
	}
	*/

}


/*
 * UPDATE
 */

void NutriModule::updateSensors() {

	for(int i=0; i<SENS_NUM; i++) {
		SENS_VALS[i] = analogRead(SENS_PINS[i]);
		SENS_AVG[i] += SENS_VALS[i];
	}

	SENS_AVG_COUNT++;

	if(SENS_AVG_COUNT >= SENS_AVG_LEN) {
		for(int i=0; i<SENS_NUM; i++) {
			float temp = ((float)SENS_AVG[i])/SENS_AVG_LEN;
			SENS_RES[i] = (int)temp;

			SENS_AVG[i] = 0;
		}

		int temp = 0;
		for(int i=0; i<SENS_NUM; i++) {
			temp += SENS_RES[i];
		}

		int total = temp/SENS_NUM;
		WEIGHT_PREV = WEIGHT_CUR;
		WEIGHT_CUR = total;
		SENS_AVG_COUNT = 0;

		if(LOG_DEBUG) Serial << MODULE_NUM << ": " << WEIGHT_CUR << endl;

	}

}

void NutriModule::updateData() {

	float percent = ( ((float)WEIGHT_CUR)/((float)WEIGHT_FULL) )*100.0;
	int val = (int)percent;

	if(LOG_DEBUG) Serial << "percent: " << percent << " & val: " << val << endl;

	Serial.print("!");
	Serial.print("M");
	Serial.print(MODULE_NUM);
	Serial.print(":");
	Serial.print(val);
	Serial.print("~");

}


/*
 * INPUT OUTPUT
 */

void NutriModule::blink(uint8_t rep, uint8_t del) {

	if(BLINK_COUNT >= rep) {
		rep = 0;
		BLINK_COUNT = 0;
		return;
	}

	if(millis()-LAST_BLINK >= del) {
		digitalWrite(LED_PIN, !digitalRead(LED_PIN));
		LAST_BLINK = millis();
		BLINK_COUNT++;
	}

	/*
	// :P
	for(int i=0; i<rep; i++) {
	  digitalWrite(LED_PIN, HIGH);
	  delay(del);
	  digitalWrite(LED_PIN, LOW);
	  delay(del);
	}
	*/

}

void NutriModule::ledOn() {
	digitalWrite(LED_PIN, HIGH);
}

void NutriModule::ledOff() {
	digitalWrite(LED_PIN, LOW);
}


