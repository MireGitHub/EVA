/* http://dev.hacklabterni.org/projects/didattica/wiki/Didattica */


const int pingPin = 4; //identifica il pin del sensore

void setup() {
  Serial.begin(9600);  // inizializza la comunicazione seriale
}

void loop()
{
  long duration, inches, cm;  //stabilisce le variabili della durata e delle unita' di misurazione della distanza

  pinMode(pingPin, OUTPUT);    //stabilisce che il pin 4 agisce come output
  digitalWrite(pingPin, LOW);  //da' un impulso LOW per ripulire il segnale
  delayMicroseconds(2);        //attende 2 microsecondi prima di procedere
  digitalWrite(pingPin, HIGH); //da' l'impulso che fa partire gli ultrasuoni
  delayMicroseconds(5);        //attende 5 microsecondi
  digitalWrite(pingPin, LOW);  

  pinMode(pingPin, INPUT);            //modifica il pin 4 come input per ricevere il segnale di ritorno
  duration = pulseIn(pingPin, HIGH);  //misura il tempo che impiega il segnale a tornare

  inches = microsecondsToInches(duration);   //converte il tempo in pollici
  cm = microsecondsToCentimeters(duration);  //converte il tempo in centimetri

  Serial.print(inches);  //scrive  la distanza calcolata nella finestra di controllo
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();

  delay(100);
}

long microsecondsToInches(long microseconds)
{
  return microseconds / 74 / 2;  //calcola la distanza in pollici
}

long microsecondsToCentimeters(long microseconds)
{
  return microseconds / 29 / 2;  //calcola la distanza in centimetri
}
