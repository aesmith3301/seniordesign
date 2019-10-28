#include <Stepper.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
// for your motor

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);

int steps = 0;         // number of steps the motor has taken
int dirStep = 0;
const int button1Pin = 2;
const int button2Pin = 3;
const int safetybutton1 = 5;


void setup() {
  myStepper.setSpeed(60);
  // initialize the serial port:
  Serial.begin(9600);
  pinMode(button1Pin, INPUT);
  pinMode(button2Pin, INPUT);
  pinMode(safetybutton1, INPUT);
}

void loop() {
  

int button1State, button2State, safetystate1, safetystate2;
    button1State = digitalRead(button1Pin);
    button2State = digitalRead(button2Pin);
    safetystate1 = digitalRead(safetybutton1);
    
if (safetystate1 == 1)
  dirStep = 0;
  steps = 0;
  myStepper.step(dirStep);
  Serial.println(dirStep);

if (safetystate1 == 0)

  if ((button1State == 0) && (button2State == 0))
     dirStep = 0;
     steps = 0;
     myStepper.step(dirStep);
     Serial.println(dirStep);


  if ((button1State == 1) && (button2State == 0))
     dirStep = 1;
     steps = 1;
     myStepper.step(dirStep);
     Serial.println(dirStep);

  if ((button1State == 0) && (button2State == 1))
     dirStep = -1;
     steps = 1;
     myStepper.step(dirStep);
     Serial.println(dirStep);

Serial.print(safetystate1);
     

  delayMicroseconds(100);
}
