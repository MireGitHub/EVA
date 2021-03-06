

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
String uid="";

int wait = 3000;
int m;
int TEXT_ON_OFF = 0;
int START_ON_OFF = 0;


void setup(){
  //wRed=wGreen=wBlue=0;
 size(200,200);
 println(Serial.list());
 port = new Serial(this, "/dev/cu.usbmodemFD131", 115200); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
 myRemoteLocationInfoBeamer = new NetAddress("156.148.33.113",5555);
 m = millis();
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
  //println("serial "+serial);
  //println("char serial serial "+char(serial));
 //if(serial != '\n') {
   buff += char(serial);
   
 //} else {
   
   if(buff.indexOf("The_UID:")>-1){
     //println("buff"+ buff);
     uid=split(buff,"The_UID:")[1];
     uid=split(uid,"**")[0];
     //println("uid "+uid);
     uid=uid.trim();
     if(uid.trim().equals("A76CD594")){
        
       if( !uid.equals(last_send) ){
        OscMessage myMessage = new OscMessage("/photo/playlist/2.txt");
        //myMessage.add("2.txt"); 
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send "+uid);
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
       if(millis()-m >= wait){
                m=millis();
                if(START_ON_OFF == 0){
                  OscMessage myMsg = new OscMessage("/photo/start/1");
                  oscP5.send(myMsg, myRemoteLocationInfoBeamer);
                  START_ON_OFF = 1;
                  println("TStart_ON");
                  println(myMsg);
                }
                else{
                    OscMessage myMessage = new OscMessage("/photo/start/2");
                    //myMessage.add(1);
                    oscP5.send(myMessage, myRemoteLocationInfoBeamer);
                    println("send start 2: "+uid);
                    println(myMessage);
                    START_ON_OFF = 0;
                }
          }
       
       /*if( !uid.equals(last_send) ){
         
        OscMessage myMessage = new OscMessage("/photo/start/"+1);
         println(myMessage);
        //myMessage.add(1);
        oscP5.send(myMessage, myRemoteLocationInfoBeamer);
        println("send play"+uid);
        println(myMessage);
        last_send=uid;
       } */
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
     }
     
      if(uid.trim().equals("745F82CB")){
        
        
        //println("read 745F82CB");
        
        //println("m "+m);
        //println("m1 "+m1);
        //println("Now: ",now);
          if(millis()-m >= wait){
                m=millis();
                if(TEXT_ON_OFF == 0){
                  OscMessage myMsg = new OscMessage("/photo/text_info/1");
                  oscP5.send(myMsg, myRemoteLocationInfoBeamer);
                  TEXT_ON_OFF = 1;
                  println("Text_ON");
                  println(myMsg);
                }
                else{
                    OscMessage myMessage = new OscMessage("/photo/text_info/0");
                    //myMessage.add(1);
                    oscP5.send(myMessage, myRemoteLocationInfoBeamer);
                    println("send text info OFF: "+uid);
                    println(myMessage);
                    TEXT_ON_OFF = 0;
                }
          }
     }
   }

 }