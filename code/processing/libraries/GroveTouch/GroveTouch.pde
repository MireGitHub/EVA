
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
int ON = 1, OFF = 0;

String buff = "";
String pin="";
int gestureCounter = 0;  // No gesture 
String gestureSeq = "";

String oscMapper = "/photo/";
String oscChildMapper ="/slideshow/";
int etaRead = -1;
int START_ON_OFF = OFF;
int TEXT_ON_OFF = OFF;
int wait = 2000;

void setup(){
  
 size(200,200);
 //println(Serial.list());
 port = new Serial(this, "/dev/ttyACM2", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("192.168.1.199",5555);  //LAN connection 
 //myRemoteLocationInfoBeamer = new NetAddress("156.148.33.166",5555);  //WI-FI connection

 etaRead=millis(); //when the tag is detected
}
 


void draw(){
  
 background(0,100,200);
 
 // check for serial, and process
 while (port.available() > 0) {
   //println("port.read() "+port.read());
   serialEvent(port.readChar());
 };
 
 buff="";
 text("GESTURE & TOUCH SENSOR",10,30);
 text(pin,10,100);

}

void serialEvent(char serial) {
  
  if(resetCmd(serial).equals("RESET_KO")){ //<>//
    
     buff = "";
     buff += serial;
     pin = buff; 
     println("PIN:", pin);
     pin = pin.trim();
    
    switch(pin){
       
         case("0"):  // PLAY and PAUSE
               if( millis() - etaRead >= wait ){
               etaRead = millis();
              
                   if( START_ON_OFF == OFF) {
                    sendOscMessage(oscMapper+"start/1", pin);
                    sendOscMessage(oscChildMapper+"start/1", pin);
                    START_ON_OFF = ON;
                   }
                   else {
                      sendOscMessage(oscMapper+"start/2", pin);
                      sendOscMessage(oscChildMapper+"start/2", pin);
                      START_ON_OFF = OFF;
                   }
               }
               break;
               
          case("1"):  // NEXT
                if( millis() - etaRead >= wait ){
                   etaRead = millis();
                   sendOscMessage(oscMapper+"next/1", pin);
                   sendOscMessage(oscChildMapper+"next/1", pin);
                }
               break;
               
          case("2"):  // TEXT_INFO
               if( millis() - etaRead >= wait ){
                   etaRead = millis();
              
                   if( TEXT_ON_OFF == OFF) {
                      sendOscMessage(oscMapper+"text_info/1", pin);
                      TEXT_ON_OFF = ON;
                   }
                   else {
                      sendOscMessage(oscMapper+"text_info/0", pin);
                      TEXT_ON_OFF = OFF;
                   }
               }
               break;
               
          case("3"):  // STOP and RESET
                if( millis() - etaRead >= wait ){
                   etaRead = millis();
                   
                   playerReset(pin); 
                   /*sendOscMessage(oscMapper+"start/0", pin);
                   
                   START_ON_OFF = OFF;
                   if(TEXT_ON_OFF == ON){
                     TEXT_ON_OFF = OFF;
                     sendOscMessage(oscMapper+"text_info/0", pin);
                   }
                   sendOscMessage("/videolist/vds/", pin);  //stop video and audio
                   */
                }
               break;
               
          case("L"):  //NEXT
                   sendOscMessage(oscMapper+"next/1", "SWIPE LEFT");
               break;
               
         default:
               break;
       }
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



String resetCmd(char serial){
   
    String resetStatus = "RESET_KO"; 
    
    if(serial =='R'){ //<>//
     
       gestureSeq += serial;
       gestureCounter++;   // see a right swipe gesture
     
       println("Reset seq: ", gestureSeq);
     
       if(gestureCounter > 5){  // if there are too many "R" into the buffer
           gestureCounter = 0;  // reset gesture counter and
           gestureSeq = "";      // clean the buffer
       }
     }  
   
   //if you see an "L" after an "R"
   if(serial == 'L' && gestureCounter >= 1){
      gestureSeq += serial;
      //resetCmd = gestureSeq;
      println("GESTURE SEQUENCE: "+gestureSeq+" --Gest counter:"+gestureCounter);
    
      playerReset("RESET_GESTURE");        // send an OSC reset command
      resetStatus = "RESET_OK";
      gestureSeq = "";      // clear the sequence string
      gestureCounter = 0;
   }
   
   return resetStatus;
}


void playerReset(String resetSource){
  
   sendOscMessage(oscMapper+"start/0", resetSource);
   sendOscMessage(oscChildMapper+"start/0", resetSource);              
   START_ON_OFF = OFF;
   if(TEXT_ON_OFF == ON){
     TEXT_ON_OFF = OFF;
     sendOscMessage(oscMapper+"text_info/0", resetSource);
   }
   sendOscMessage(oscMapper+"video/2", resetSource);
   sendOscMessage("/videolist/vds/2", resetSource);  //stop video and audio

}