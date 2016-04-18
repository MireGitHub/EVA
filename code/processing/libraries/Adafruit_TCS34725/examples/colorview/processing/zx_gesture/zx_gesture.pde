/* For use with the colorview Arduino example sketch 
   Update the Serial() new call to match your serial port
   e.g. COM4, /dev/usbserial, etc!
*/


import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress myRemoteLocationArena;
float positionx=0.0;
float scale=0.0;

PFont f; 
Serial port;
int right, left,up;
 
String buff = "";
void setup(){
  //wRed=wGreen=wBlue=0;
 size(200,200);
 println(Serial.list());
 port = new Serial(this, "/dev/cu.usbmodemFD131", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("156.148.72.120",7700);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
}
 


void draw(){
  
 background(0,100,200);
 
 // check for serial, and process
 while (port.available() > 0) {
   //println("port.read() "+port.read());
   serialEvent(port.read());
 };
 text(right+" "+left+" "+up+" "+positionx+" "+scale,10,100);
 //text(buff,10,100);

  
  //nuovo messaggio
  OscMessage myMessage = new OscMessage("/activeclip/video/anchorx/values");
  myMessage.add(0.5+positionx/4096.0); 
  oscP5.send(myMessage, myRemoteLocationArena);

    //nuovo messaggio
   myMessage = new OscMessage("/activeclip/video/scale/values");
  myMessage.add(0.1+scale/1000.0); 
  oscP5.send(myMessage, myRemoteLocationArena);
  
}

void serialEvent(int serial) {
  //println("serial "+serial);
  //println("char serial serial "+char(serial));
 if(serial != '\n') {
   buff += char(serial);
 } else {
   println("buff"+ buff);
   if(buff!=""){
     try{
      String[] list = split(buff, ' ');
      if(list.length==2){
        if(list[0].equals("right")){
          println("right");
          right=int(list[1].trim());
          left=0;up=0;
          positionx=positionx+right+0.001;
        };
        if(list[0].equals("left")){
          println("left");
         left =int(list[1].trim());
          right=0;up=0;
          positionx=positionx-left+0.001;
        };
        if(list[0].equals("up")){
         up =int(list[1].trim());
         scale=scale+up+0.001;
         right=0;left=0;
         if(scale>100){scale=0;};
        };
        println(right+" "+left+" "+up+" "+positionx/4096.0);
      }
     }catch(Exception e){e.printStackTrace();};
   }
   buff="";
   
 }
}