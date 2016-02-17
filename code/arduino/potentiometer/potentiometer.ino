/******************************************/
const int analogPin = A0;//the analog input pin attach to
const int ledPin = 3;//the led attach to

const int greenPin= 3; //the green led pin attact to
const int whitePin= 5; //the yellow led pin attact to
const int redPin= 2; //the red led pin attach to

int inputValue = 0;//variable to store the value coming from sensor
int outputValue = 0;//variable to store the output value

String comdata = "";
int lastLength = 0;
/*********************************************************/
void setup()
{
 
  pinMode(greenPin,OUTPUT);  //initialize the greenPin as output
  pinMode(whitePin, OUTPUT);  //initialize the yellowPin as output
  pinMode(redPin, OUTPUT);  //initialize the redPin as output
  Serial.begin(9600);  // start serial port at 9600 bps:
  Serial.print("Please input any color of LED:");  //print message on serial monitor
}
/*********************************************************/
void loop()
{
   
    inputValue = analogRead(analogPin);//read the value from the sensor
    outputValue = map(inputValue,0,1023,0,255);//Convert from 0-1023 proportional to the number of a number of from 0 to 255
    analogWrite(ledPin,outputValue);//turn the led on depend on the output value
   
    Serial.print(outputValue ,'\n');

    //read string from serial monitor
  if(Serial.available()>0)  // if we get a valid byte, read analog ins:
  { 
    comdata = "";
    while (Serial.available() > 0) 
    {       
      comdata += char(Serial.read());
      delay(2);
    }
    Serial.println(comdata);
  }
  
    if(comdata == "red")
    {
      digitalWrite(redPin, HIGH);//turn the red led on
      digitalWrite(greenPin, LOW);//turn the green led off
      digitalWrite(whitePin, LOW);//turn the yellow led off
    }
    else if(comdata == "white")
    {
      digitalWrite(redPin, LOW);//turn the red led off
      digitalWrite(greenPin, LOW);//turn the green led off
      digitalWrite(whitePin, HIGH);//turn the yellow led on
    }
    else if(comdata == "green")
    {
      digitalWrite(redPin, LOW);//turn the red led off
      digitalWrite(greenPin, HIGH);//turn the green led on
      digitalWrite(whitePin, LOW);//turn the yellow led off
    }
    else
    {
      digitalWrite(redPin, LOW);//turn the red led off
      digitalWrite(greenPin, LOW);//turn the green led off
      digitalWrite(whitePin, LOW);//turn the yellow led off
    }   
    
    
    if(outputValue > 10 && outputValue <= 40)
      digitalWrite(redPin, HIGH);//turn the red led on
    else if(outputValue > 40 && outputValue <= 80)
      digitalWrite(whitePin, HIGH);//turn the yellow led on
}
/************************************************************/
