
import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress myRemoteLocationArena;
NetAddress myRemoteLocationInfoBeamer;
String last_send="------------";
PFont f; 
Serial port;

String buff = "";
String pin="";
String oscMapper = "/photo/";
int etaRead = -1;
int START_ON_OFF = 0;
int TEXT_ON_OFF = 0;
int wait = 2000;

void setup(){
  
 size(200,200);
 //println(Serial.list());
 port = new Serial(this, "/dev/ttyACM0", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.113",5555);
 etaRead=millis(); //when the tag is detected
}
 


void draw(){
  
 background(0,100,200);
 
 // check for serial, and process
 while (port.available() > 0) {
   //println("port.read() "+port.read());
   serialEvent(port.read());
 };
 
 buff="";
 text(pin,10,100);

}

void serialEvent(int serial) {
   buff = "";
   buff += char(serial);
   pin = buff; 
   pin = pin.trim();
   
  switch(pin){
     
       case("0"):  // PLAY and PAUSE
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
                 if( START_ON_OFF == 0) {
                  sendOscMessage(oscMapper+"start/1", pin);
                  START_ON_OFF = 1;
                 }
                 else {
                    sendOscMessage(oscMapper+"start/2", pin);
                    START_ON_OFF = 0;
                 }
             }
             break;
             
        case("1"):  // NEXT
              if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"next/1", pin);
              }
             break;
             
        case("2"):  // TEXT_INFO
             if( millis() - etaRead >= wait ){
                 etaRead = millis();
            
                 if( TEXT_ON_OFF == 0) {
                    sendOscMessage(oscMapper+"text_info/1", pin);
                    TEXT_ON_OFF = 1;
                 }
                 else {
                    sendOscMessage(oscMapper+"text_info/0", pin);
                    TEXT_ON_OFF = 0;
                 }
             }
             break;
             
        case("3"):  // STOP and RESET
              if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"start/0", pin);
                 
                 START_ON_OFF = 0;
                 if(TEXT_ON_OFF == 1){
                   TEXT_ON_OFF = 0;
                   sendOscMessage(oscMapper+"text_info/0", pin);
                 }
              }
             break;
     }
  
 }
 
/*Create and send an osc message to the remote destination
@param msgToSend OSC message to send to the remote destinatation
@param pin touched pin
@return
*/ 
void sendOscMessage(String msgToSend, String pin){
  OscMessage myMessage = new OscMessage(msgToSend);
  oscP5.send(myMessage, myRemoteLocationInfoBeamer);
  oscEvent(myMessage);
  println("TOUCHED PIN: "+pin+" -- OSC message: "+myMessage);
}
 
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
/* get and print the address pattern and typetag of the received OscMessage */
println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag" +theOscMessage.typetag());
theOscMessage.print();
}