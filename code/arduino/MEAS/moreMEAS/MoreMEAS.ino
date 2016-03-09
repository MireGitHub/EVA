
int analogPin1 = A1; // input for 1st vibration sensor (MEAS)
int analogPin2 = A2; // input for 2nd vibration sensor (MEAS)

int ledPin13 = 13; 
int ledPin12 = 12;

int val0 = 1;   // variable to store the value read
int val1 = 2;

int high = 800;

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin12, OUTPUT);
  pinMode(ledPin13, OUTPUT);

  digitalWrite(ledPin12, LOW);
  digitalWrite(ledPin13, LOW);
}

void loop()
{
  val0 = analogRead(analogPin1);
  val1 = analogRead(analogPin2);

  if (val0 > high && val1 < high)
  {
    digitalWrite(ledPin12, HIGH);
    delay(1000);
  }
  else
    digitalWrite(ledPin12, LOW);
    
  if (val0 < high && val1 > high)
  {
    digitalWrite(ledPin13, HIGH);
    delay(1000);
  }
  else
    digitalWrite(ledPin13, LOW);

}

