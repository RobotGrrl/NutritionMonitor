int SIM_TICKS = 0;
int SIM_DURATION = 40;
boolean SIM_RUN = false;


void initSimulation() {
  
  for(int i=0; i<3; i++) {
    MODULE_CURRENT[i] = 100;
    DAY_START_VAL[DAY_NUM][i] = 100;
  }
  
  SIM_DURATION = 20;
  SIM_TICKS = 0;
  SIM_RUN = true;
}


void tickSimulation() {
  
  steadyMunchSimulation();
  //allZero();
  
  SIM_TICKS++;
  
  if(SIM_TICKS >= SIM_DURATION) {
    println("Simulation complete");
    SIM_RUN = false;  
  }
  
}


void steadyMunchSimulation() {
  
  //if(SIM_TICKS%3 == 0) incrementDay();
  incrementDay();
  
  int upperBound =  100/20;
  for(int i=0; i<3; i++) {
    MODULE_CURRENT[i] -= (int)random(0, upperBound+1);
    if(MODULE_CURRENT[i] < 0) MODULE_CURRENT[i] = 0;
  }
  
  if(DAY_START_MUST) {
    calculateMUST();
    calculatePortionRemaining();
  }
  
}

void allZero() {
  
  incrementDay();
  
  for(int i=0; i<3; i++) {
    MODULE_CURRENT[i] = 0;
    MODULE_PORTION_REMAINING[i] = 0;
  }
  MUST_TOTAL_SCORE = 0;
}

