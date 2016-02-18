const int switch1Pin = 6;    // switch input 1
const int switch2Pin = 7;    // switch input 2
const int led1Pin = 8;
const int led2Pin = 9;

void setup() {
    // set the switch as an input:
    pinMode(switch1Pin, INPUT); 
    pinMode(switch2Pin, INPUT);
    
    // set all the other pins you're using as outputs:
    pinMode(led1Pin, OUTPUT); 
    pinMode(led2Pin, OUTPUT); 
}

void loop() {
    // if the switch is high, motor will turn on one direction:
    if (digitalRead(switch1Pin) == HIGH) {
    digitalWrite(led1Pin, LOW);   // set leg 1 of the H-bridge low
    digitalWrite(led2Pin, HIGH);  // set leg 2 of the H-bridge high
  } 
    // if the switch is low, motor will turn in the other direction:
  else if(digitalRead(switch2Pin) == HIGH){
    digitalWrite(led1Pin, HIGH);   // set leg 1 of the H-bridge low
    digitalWrite(led2Pin, LOW);   // set leg 2 of the H-bridge low
  }
  else {
    digitalWrite(led1Pin, LOW);   // set leg 1 of the H-bridge low
    digitalWrite(led2Pin, LOW);   // set leg 2 of the H-bridge low    
  }
}

