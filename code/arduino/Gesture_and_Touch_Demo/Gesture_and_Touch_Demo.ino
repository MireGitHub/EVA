/* GroveI2CTouchTest.pde - Sample code for the SeeedStudio Grove I2C Touch Sensor
http://seeedstudio.com/wiki/index.php?title=Twig_-_I2C_Touch_Sensor_v0.93b  
Prerequisite: A modification of the Grove I2C Touch sensor is needed Solder a pin to
the INT terminal in the I2C sensor to connect it to one pin in Arduino  Created by
Wendell A. Capili, August 27, 2011. http://wendellinfinity.wordpress.com  
Released into the public domain.


Gesture Sensor hardware connections:
 
 Arduino Pin  ZX Sensor Board  Function
 ---------------------------------------
 5V           VCC              Power
 GND          GND              Ground
 A4           DA               I2C Data
 A5           CL               I2C Clock

Resources:
Include Wire.h and ZX_Sensor.h


*/

#include <Wire.h> // include I2C library
#include <i2c_touch_sensor.h>
#include <mpr121.h>
#include <ZX_Sensor.h>

// Constants
const int ZX_ADDR = 0x10;    // ZX Sensor I2C address
// Global Variables
ZX_Sensor zx_sensor = ZX_Sensor(ZX_ADDR);
GestureType gesture;
uint8_t gesture_speed;

// include our Grove I2C touch sensor library
// initialize the Grove I2C touch sensor
// IMPORTANT: in this case, INT pin was connected to pin7 of the Arduino 
// (this is the interrupt pin)
i2ctouchsensor touchsensor; // keep track of 4 pads' states

long previousMillis = 0;
long interval = 100;

void setup() 
  {    
    uint8_t ver; 
    
    Serial.begin(9600); // for debugging   
     
    Wire.begin(); // needed by the GroveMultiTouch lib     
    touchsensor.initialize(); // initialize the feelers     // initialize the containers     
  
    // Initialize ZX Sensor (configure I2C and read model ID)
  if ( zx_sensor.init() ) {
    //Serial.println("ZX Sensor initialization complete");
  } else {
    Serial.println("Something went wrong during ZX Sensor init!");
  }
  
  // Read the model version number and ensure the library will work
  ver = zx_sensor.getModelVersion();
	
  }
void loop()
{  
  
 unsigned char MPR_Query=0;
 unsigned long currentMillis = millis();
 if(currentMillis - previousMillis > interval)
  {
    previousMillis = currentMillis;
    touchsensor.getTouchState();
  }
 for (int i=0;i<12;i++)
 {
   if (touchsensor.touched&(1<<i))
   {
    Serial.print(i);
    Serial.print("\n");
   }
 }
 
 
 // If there is gesture data available, read and print it
  if ( zx_sensor.gestureAvailable() ) {
    gesture = zx_sensor.readGesture();
    gesture_speed = zx_sensor.readGestureSpeed();
    switch ( gesture ) {
      /*case NO_GESTURE:
        Serial.println("No Gesture");
        break;*/
      case RIGHT_SWIPE:
        Serial.print("RIGHT_SWIPE:");
        Serial.println(gesture_speed, DEC);
        break;
      case LEFT_SWIPE:
        Serial.print("LEFT_SWIPE:");
        Serial.println(gesture_speed, DEC);
        break;
      /*case UP_SWIPE:
        Serial.print("Up Swipe. Speed: ");
        Serial.println(gesture_speed, DEC);
        break;*/
      default:
        break;
    }
  }
}  

