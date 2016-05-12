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
String uid=""; //nfc tag identifier
String oscMapper = "/photo/";
int etaRead;
int wait = 2000;    //waiting time before the next UID read
int START_ON_OFF = 0;
int TEXT_ON_OFF = 0;
int VIDEO_ON_OFF = 0;

void setup(){
  
 size(200,200);
 port = new Serial(this, "dev/ttyACM0", 115200); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.113",5555);
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

       case("B4FF8BCB"):     //PLAYLIST 2
             if(millis() - etaRead >= wait){
                etaRead = millis();
                sendOscMessage("/photo/playlist/2.txt", uid);
             }
             break;

        case("845B82CB"):       //PLAY and PAUSE
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( START_ON_OFF == 0) {
                sendOscMessage(oscMapper+"start/1", uid);
                START_ON_OFF = 1;
               }
             else {
                sendOscMessage(oscMapper+"start/2", uid);
                START_ON_OFF = 0;
               }
             }
             break;

        case("745F82CB"):       //INFO
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( TEXT_ON_OFF == 0) {
                  sendOscMessage(oscMapper+"text_info/1", uid);
                  TEXT_ON_OFF = 1;
               }
               else {
                  sendOscMessage(oscMapper+"text_info/0", uid);
                  TEXT_ON_OFF = 0;
               }
             }
             break;
      
       case("B4F382CB"):       //STOP
             if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"start/0", uid);
                 
                 START_ON_OFF = 0;
                 if(TEXT_ON_OFF == 1){
                   TEXT_ON_OFF = 0;
                   sendOscMessage(oscMapper+"text_info/0", uid);
                 }
              }
             break;
             
       case("24E97BCB"):       //NEXT
            if( millis() - etaRead >= wait ){
                 etaRead = millis();
                 sendOscMessage(oscMapper+"next/1", uid);
              }
             break;
             
       case("94B082CB"):       //VIDEO or AUDIO
             if( millis() - etaRead >= wait ){
             etaRead = millis();
            
             if( START_ON_OFF == 0) {
                sendOscMessage(oscMapper+"video/1", uid);
                VIDEO_ON_OFF = 1;
               }
             else {
                sendOscMessage(oscMapper+"video/0", uid);
                VIDEO_ON_OFF = 0;
               }
             }
             break;      
       default:             // Default executes if the case labels
              println("Waiting to read...");   // don't match the switch parameter
              break;
     }
     
     
     /*if(uid.trim().equals("A76CD594")){

       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/playlist/2.txt");
        //myMessage.add("2.txt");
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        //println("send "+uid);
        last_send=uid;
       }
     }

     if(uid.trim().equals("24E97BCB")){

       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/playlist/3.txt");
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send "+uid);
        last_send=uid;
       }
     }
     if(uid.trim().equals("A48D7BCB")){

       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/playlist/4.txt");
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send "+uid);
        last_send=uid;
       }
     }
     if(uid.trim().equals("845B82CB")){

       if( !uid.equals(last_send) ){

        OscMessage myMessage = new OscMessage("/photo/start/"+1);
         println(myMessage);
        //myMessage.add(1);
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send play"+uid);
        println(myMessage);
        last_send=uid;
       }
     }
     if(uid.trim().equals("94B082CB")){

       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/start/"+2);
        //myMessage.add(1);
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send pause"+uid);
        println(myMessage);
        last_send=uid;
       }
     }
          if(uid.trim().equals("24E97BCB")){

       //if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/next/"+1);
        //myMessage.add(1);
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send next"+uid);
        println(myMessage);
        last_send=uid;
       //}
     } */
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