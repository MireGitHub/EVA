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

PFont f; 
Serial port;
 int wRed; 
 int wGreen; 
 int wBlue; 
 int wClear;
 
 
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
 
 
String buff = "";


String hexColor = "ffffff";
 

void draw(){
  
 background(wRed,wGreen,wBlue);
 
 // check for serial, and process
 while (port.available() > 0) {
   //println("port.read() "+port.read());
   serialEvent(port.read());
 };
 text(wRed+" "+wGreen+" "+wBlue,10,100);
 
 ////////// send osc BLU //////////////
   OscMessage myMessage = new OscMessage("/2/fader5");
  myMessage.add(wBlue/255.0); /* add an int to the osc message */
  println("/2/fader5  "+wBlue/255.0);
  oscP5.send(myMessage, myRemoteLocation); 

  
 
 ////////// send osc ROSSO //////////////
   myMessage = new OscMessage("/2/fader4");
  myMessage.add(wRed/255.0); /* add an int to the osc message */
  oscP5.send(myMessage, myRemoteLocation); 

 
 ////////// send osc VERDE //////////////
   myMessage = new OscMessage("/2/fader7");
  myMessage.add(wGreen/255.0);
  oscP5.send(myMessage, myRemoteLocation); 
 
  /*
  //nuovo messaggio
  myMessage = new OscMessage("/layer1/clip1/connect");
  myMessage.add(1); /* add an int to the osc message  
  oscP5.send(myMessage, myRemoteLocationArena);
 */
}

void serialEvent(int serial) {
  //println("serial "+serial);
  //println("char serial serial "+char(serial));
 if(serial != '\n') {
   buff += char(serial);
 } else {
   //println("buff"+ buff);
   if(buff!=""){
     try{
      String[] list = split(buff, ' ');
      if(list.length>2){
      println(list.length);
      //println("list0"+ list[0]);
      //println("list1"+ list[1]);
      //println("list2"+ list[2]);
      //wBlue=int(split(list[2],"=")[1]);
      wRed=int(split(list[0],"=")[1]);
      wGreen=int(split(list[1],"=")[1]);
      //println(split(list[2],"=")[1]);
      //println(split(list[2],"=")[1]);
      //println("wRed "+ wRed);
      //println("wGreen "+ wGreen);
      wBlue=Integer.parseInt( (split(list[2],"=")[1]).trim() );
      //println("wBlue "+ wBlue);
      }
     }catch(Exception e){e.printStackTrace();};
   }
   buff="";
   
 }
}