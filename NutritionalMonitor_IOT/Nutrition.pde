int DAY_NUM = 0;
int[][] DAY_START_VAL = new int[3][3];
boolean DAY_START_MUST = false;
long LAST_TWEET = 0;

float BMI = 0;

float MUST_BMI_SCORE = 0;
float MUST_DAY_SCORE = 0;
float MUST_TOTAL_SCORE = 0;
int MUST_TICK = 0;

int[] MODULE_AVG = new int[3];
int[] MODULE_COUNT = new int[3];
int[] MODULE_CURRENT = new int[3];
int[] MODULE_PREV = new int[3];
boolean MODULE_TEST_POPULATED = false;
int[] MODULE_PORTION_REMAINING = new int[3];


void initNutrition() {
  initBMI();
  DAY_NUM = 0;
  initDayVals();
  initModVals();
}


void incrementDay() {
  
  if(DAY_NUM == 2) {
    for(int i=0; i<3; i++) {
      DAY_START_VAL[0][i] = DAY_START_VAL[1][i];
      DAY_START_VAL[1][i] = DAY_START_VAL[2][i];
    }
    DAY_NUM = 2;
    DAY_START_MUST = true;
  } else {
    DAY_NUM++;
  }
  
  for(int i=0; i<3; i++) {
    DAY_START_VAL[DAY_NUM][i] = MODULE_CURRENT[i];
  }
  
  if(DAY_START_MUST) {
    for(int i=0; i<3; i++) {
      int CHANGE_A = DAY_START_VAL[0][i]-DAY_START_VAL[1][i];
      int CHANGE_B = DAY_START_VAL[1][i]-DAY_START_VAL[2][i];
      int CHANGE_C = MODULE_CURRENT[i];
      
      //println("A= " + CHANGE_A + " B= " + CHANGE_B + " C= " + CHANGE_C);
      
      if(CHANGE_C == 0) {
        MODULE_AVG[i] = 0;
      } else {
        float temp = ( ( abs( (float)CHANGE_B - (float)CHANGE_A ) - (float)CHANGE_C ) / (float)CHANGE_C )*100.0;
        //println("temp: " + temp);
        MODULE_AVG[i] = (int)temp;
      }
      
      //println("module avg: " + i + " : " + MODULE_AVG[i]);
      
      if(MODULE_AVG[i] <= -80) {
        //println("bad");
        MUST_DAY_SCORE += 0.1;
      } else if(MODULE_AVG[i] <= -50) {
        //println("yikes"); 
        MUST_DAY_SCORE += 0.05;
      } else if(MODULE_AVG[i] == 0.0) {
        MUST_DAY_SCORE += 0.8;
      }
      
      if(MODULE_AVG[i] >= 50) {
        //println("bad");
        MUST_DAY_SCORE -= 0.3;
      } else if(MODULE_AVG[i] >= 20) {
        //println("yikes"); 
        MUST_DAY_SCORE -= 0.1;
      }
      
    }
    
    MUST_TICK++;
    
    if(MUST_DAY_SCORE > 2) MUST_DAY_SCORE = 2;
    
    if(MUST_TICK%3 == 0) {
      MUST_DAY_SCORE -= 0.4;
      if(MUST_DAY_SCORE < 0) MUST_DAY_SCORE = 0;
    }
    
    //println("MUST SCORE: " + MUST_DAY_SCORE);
    calculateMUST();
    calculatePortionRemaining();
    
  }
  
}


void calculateMUST() {
  MUST_TOTAL_SCORE = MUST_BMI_SCORE + MUST_DAY_SCORE;
  if(MUST_TOTAL_SCORE > 2) MUST_TOTAL_SCORE = 2;
  if(MUST_TOTAL_SCORE < 0) MUST_TOTAL_SCORE = 0;
  
  if(MUST_TOTAL_SCORE >= MUST_THRESH) {
    if(millis()-LAST_TWEET >= (3*60*1000) || LAST_TWEET == 0) {
      //println("---------------going to tweet");
      sendTweet("@RobotGrrl [ALERT] Nutrition monitor exceeded threshold || [" + millis() + "]");
      LAST_TWEET = millis();
    }
  }
  
}


void calculatePortionRemaining() {
 
  for(int i=0; i<3; i++) {
    
    float temp1 = ( (float)DAY_START_VAL[1][i] - (float)DAY_START_VAL[2][i] );
    float temp2 = ( (float)DAY_START_VAL[2][i] - (float)MODULE_CURRENT[i] );
    /*
    if(temp1 < 0) {
      temp1 += DAY_START_VAL[1][i];
      temp1 += (100-DAY_START_VAL[2][i]);
    }
    
    if(temp2 < 0) {
      temp2 += DAY_START_VAL[2][i];
      temp2 += (100-MODULE_CURRENT[i]);
    }
    */
    MODULE_PORTION_REMAINING[i] = 100-( (int)((temp2/temp1 )*100) );
    //if(temp1 == 0 || temp2 == 0) MODULE_PORTION_REMAINING[i] = 0;
    if(MODULE_PORTION_REMAINING[i] < 0) MODULE_PORTION_REMAINING[i] = 0;
    if(MODULE_PORTION_REMAINING[i] > 100) MODULE_PORTION_REMAINING[i] = 100;
    
    //println("temp 1: " + temp1 + " 2: " + temp2 + " r: " + MODULE_PORTION_REMAINING[i]);
    
  }
  
}


void simulateModule(int i) {
  
  if(!MODULE_TEST_POPULATED) {
    for(int ii=0; ii<3; ii++) {
      MODULE_CURRENT[ii] = 100;
      DAY_START_VAL[DAY_NUM][ii] = 100;
    }
    MODULE_TEST_POPULATED = true;
  }
  
  int RANDOM_SUBTRACT = (int)random(10, 50);
  //println("random subtract = " + RANDOM_SUBTRACT);
  //println("current: " + MODULE_CURRENT[i]);
  
  MODULE_PREV[i] = MODULE_CURRENT[i];
  MODULE_CURRENT[i] -= RANDOM_SUBTRACT;
  if(MODULE_CURRENT[i] < 0) MODULE_CURRENT[i] = 0;
  
  if(DAY_START_MUST) calculatePortionRemaining();
  
}





/*
 * Misc
 */

void initDayVals() {
  
  for(int j=0; j<3; j++) {
    for(int i=0; i<3; i++) {
      DAY_START_VAL[j][i] = 0;
    }
  }
  DAY_START_MUST = false;
  DAY_NUM = 0;
  
}


void initModVals() {
 
  for(int i=0; i<3; i++) {
    MODULE_AVG[i] = 0;
    MODULE_COUNT[i] = 0;
    MODULE_CURRENT[i] = 0;
    MODULE_PREV[i] = 0;
    MODULE_PORTION_REMAINING[i] = 0;
  }
  MODULE_TEST_POPULATED = false;
  
}


void initBMI() {
 
  float MASS_KG = MASS_LB * 0.4536;
  float HEIGHT_M = HEIGHT_IN * 0.0254;
  
  BMI = ( MASS_KG / ( pow(HEIGHT_M, 2) ) );
  //println("BMI: " + BMI);
  
  if(BMI > 20) {
    MUST_BMI_SCORE = 0.0;  
  } else if(BMI >= 18.5 && BMI <= 20) {
    MUST_BMI_SCORE = 0.25;
  } else if(BMI < 18.5) {
    MUST_BMI_SCORE = 0.5;
  }
  
  MUST_DAY_SCORE = 0;
  MUST_TOTAL_SCORE = 0;
  LAST_TWEET = 0;
  
  //println("MUST BMI SCORE: " + MUST_BMI_SCORE);
  
}


void printDayVals() {
  println("DAY 0- #0: " + DAY_START_VAL[0][0] + " #1: " + DAY_START_VAL[0][1] + " #2: " + DAY_START_VAL[0][2]);
  println("DAY 1- #0: " + DAY_START_VAL[1][0] + " #1: " + DAY_START_VAL[1][1] + " #2: " + DAY_START_VAL[1][2]);
  println("DAY 2- #0: " + DAY_START_VAL[2][0] + " #1: " + DAY_START_VAL[2][1] + " #2: " + DAY_START_VAL[2][2]);
}


void printModCurrent() {
  println("MOD 1: " + MODULE_CURRENT[0] + " 2: " + MODULE_CURRENT[1] + " 3: " + MODULE_CURRENT[2]);
}


void testPopulateDayVals() {

  for(int i=0; i<3; i++) {
    DAY_START_VAL[DAY_NUM][i] = (int)random(0, 100);
  }
  
}


void updateCurrentVal(int i, int val) {
  
  println("ARDUINO VAL ::::::::::::::::::::::::::::::::::::::::: " + val);
  
  MODULE_CURRENT[i] = val;
  
  if(DAY_START_MUST) {
    calculateMUST();
    calculatePortionRemaining();
  }
  
}


