
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
int val_time=-1;
int START_ON_OFF = 0;
int wait = 3000;

void setup(){
  
 size(200,200);
 println(Serial.list());
 port = new Serial(this, "/dev/ttyACM0", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.113",5555);

 val_time=millis();
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
   //println("serial "+serial);
   buff += char(serial);
   //println("Buf: " +buff);
   pin = buff; 
   pin = pin.trim();
  
     if( pin.equals("0")){
       
       if( millis() -val_time >= wait ){
          val_time = millis();
           println("START_ON_OFF: ",START_ON_OFF);
          if( START_ON_OFF == 0) {
            OscMessage myMessage = new OscMessage("/photo/start/1");
            oscP5.send(myMessage, myRemoteLocationInfoBeamer);
            println("send START: "+pin);
            println(myMessage);
            START_ON_OFF = 1;
           }
           else {
              OscMessage myMessage = new OscMessage("/photo/start/2");
              oscP5.send(myMessage, myRemoteLocationInfoBeamer);
              println("send PLAY 2:  "+pin);
              println(myMessage);
              START_ON_OFF = 0;
           }
       }
     }
     
     
     if(pin.equals("1")){
       println("PIN 1 read");
        OscMessage myMessage = new OscMessage("/photo/video/1");
        //myMessage.add("2.txt"); 
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send START VIDEO "+pin);
        println(myMessage);
       
     }
   

 }