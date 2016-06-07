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
String uid=""; //nfc tag identifier
String oscMapper = "/photo/";
String playlistMapper = oscMapper+"playlist/";
int etaRead;
int wait = 2000;    //waiting time before the next UID read
int START_ON_OFF = 0;
int TEXT_ON_OFF = 0;
int VIDEO_ON_OFF = 0;

void setup(){
  
 size(200,200);
 port = new Serial(this, "/dev/ttyACM0", 115200); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 //myRemoteLocationArena = new NetAddress("156.148.33.166",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.166",5555);
 etaRead = millis(); //when the tag is detected
}



void draw(){

 background(0,100,200);

 // check for serial, and process
 while (port.available() > 0) {
   //println("port.read() "+port.read());
   serialEvent(port.read());
 };
 buff="";
 text(uid,10,100);

}

void serialEvent(int serial) {

   buff += char(serial);

   if(buff.indexOf("The_UID:")>-1){
     //println("buff"+ buff);
     uid=split(buff,"The_UID:")[1];
     uid=split(uid,"**")[0];
     //println("uid "+uid);
     uid=uid.trim();
     
     switch(uid){

       case("A408CCB"):     //PLAYLIST 1
             if(millis() - etaRead >= wait){
                etaRead = millis();
                sendOscMessage(playlistMapper+"1", uid);
             }
             break;
             
       case("B4FF8BCB"):     //PLAYLIST 2
             if(millis() - etaRead >= wait){
                etaRead = millis();
                sendOscMessage(playlistMapper+"2", uid);
             }
             break;
             
      case("C4EE6B6E"):     //PLAYLIST 3
           if(millis() - etaRead >= wait){
              etaRead = millis();
              sendOscMessage(playlistMapper+"3", uid);
           }
           break;  
           
      case("A48D7BCB"):     //PLAYLIST 4
         if(millis() - etaRead >= wait){
            etaRead = millis();
            sendOscMessage(playlistMapper+"4", uid);
         }
         break;
         
      case("84FF8BCB"):     //PLAYLIST 5
         if(millis() - etaRead >= wait){
            etaRead = millis();
            sendOscMessage(playlistMapper+"5", uid);
         }
         break;
         
       case("94AE6B6E"):     //PLAYLIST 6
         if(millis() - etaRead >= wait){
            etaRead = millis();
            sendOscMessage(playlistMapper+"6", uid);
         }
         break;

        case("845B82CB"):       //PLAY and PAUSE
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( START_ON_OFF == OFF) {
                //sendOscMessage(playlistMapper+"0", uid);
                sendOscMessage(oscMapper+"start/1", uid);
                sendOscMessage("/slideshow/start/1", uid);
                START_ON_OFF = ON;
               }
             else {
                sendOscMessage(oscMapper+"start/2", uid);
                sendOscMessage("/slideshow/start/2", uid);
                START_ON_OFF = OFF;
               }
             }
             break;

        case("745F82CB"):       //INFO
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( TEXT_ON_OFF == OFF) {
                  sendOscMessage(oscMapper+"text_file/1", uid);
                  TEXT_ON_OFF = 1;
               }
               else {
                  sendOscMessage(oscMapper+"text_file/0", uid);
                  TEXT_ON_OFF = OFF;
               }
             }
             break;
      
       case("B4F382CB"):       //STOP
             if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"start/0", uid);
                 
                 START_ON_OFF = OFF;
                 if(TEXT_ON_OFF == ON){
                   TEXT_ON_OFF = OFF;
                   sendOscMessage(oscMapper+"text_file/0", uid);
                 }
                 if(VIDEO_ON_OFF == ON){
                   VIDEO_ON_OFF = OFF;
                    //sendOscMessage(oscMapper+"video/2", uid);
                    sendOscMessage("/videolist/vds/2", uid);
                 }    
              }
             break;
             
       case("24E97BCB"):       //NEXT
            if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"next/1", uid);
                 sendOscMessage("/slideshow/next/1", uid);
              }
             break;
             
       case("94B082CB"):       //VIDEO or AUDIO
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( VIDEO_ON_OFF == OFF) {
                sendOscMessage(oscMapper+"video/1", uid);
                sendOscMessage("/videolist/vds/1", uid);
                VIDEO_ON_OFF = ON;
               }
             else {
                //sendOscMessage(oscMapper+"video/2", uid);
                sendOscMessage("/videolist/vds/2", uid);
                VIDEO_ON_OFF = OFF;
               }
             }
             break;      
       default:             // Default executes if the case labels
              println("Waiting to read...");   // don't match the switch parameter
              break;
     }

    
   }

 }
 
 

  void sendOscMessage(String msgToSend, String uid){

    OscMessage myMessage = new OscMessage(msgToSend);
    oscP5.send(myMessage, myRemoteLocationInfoBeamer);
    oscEvent(myMessage);
    println("UID: "+uid+" -- OSC message: "+myMessage);
  }

  /* incoming osc message are forwarded to the oscEvent method. */
  void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}