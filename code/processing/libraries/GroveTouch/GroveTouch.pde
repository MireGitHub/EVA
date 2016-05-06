
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

int ora; 
String buff = "";
String uid="";



void setup(){
  //wRed=wGreen=wBlue=0;
 size(200,200);
 println(Serial.list());
 port = new Serial(this, "/dev/ttyACM2", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.113",5555);
 ora = millis();
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
  //println(uid);

}

void serialEvent(int serial) {
  println("serial "+serial);
  //println("char serial serial "+char(serial));
 //if(serial != '\n') {
   buff += char(serial);
   println("Buf: " +buff);
 //} else {
   
   
     if(uid.trim().equals("1")){
        
       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/video/1");
        //myMessage.add("2.txt"); 
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send START VIDEO "+uid);
        last_send=uid;
       }
     }
   

 }