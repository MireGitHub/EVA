
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
String oscMapper = "/photo/";
String lastSend ="";
int wRed; 
int wGreen; 
int wBlue; 
 
void setup(){
 size(200,200);
 port = new Serial(this, "/dev/ttyACM1", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("192.168.1.167",5555);
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
}
 


void draw(){
  
background(wRed,wGreen,wBlue);
 // check for serial, and process
 while (port.available() > 0) {
       delay(1000);
       serialEvent(port.readString());
 };
  text(wRed+" "+wGreen+" "+wBlue,10,100);

  
  /*
  //nuovo messaggio
  myMessage = new OscMessage("/layer1/clip1/connect");
  myMessage.add(1); /* add an int to the osc message  
  oscP5.send(myMessage, myRemoteLocationArena);
 */
}

void serialEvent(String inBuffer) {
 
 String buff = "";
 String colorName = "NOT DEFINE";
 
 if(inBuffer != "\n") {
    buff += inBuffer;
    String[] list = split(buff, ':');  //<>//
    
       try{
           wRed=int(list[0]);
           wGreen=int(list[1]);
           wBlue=int(list[2]);
           println("Color: "+ colorCheck(wRed,wGreen,wBlue) + " Red: "+ wRed+" Green: "+ wGreen+" Blue: "+ wBlue);
           buff="";
           colorName = colorCheck(wRed,wGreen,wBlue);
           
           if(!colorName.equals(lastSend)){
               switch(colorName){
                 
                 case("ORANGE"):
                       sendOscMessage(oscMapper+"orange",colorName);
                       lastSend = colorName;  
                       break;
                 case("PINK"):
                       sendOscMessage(oscMapper+"pink",colorName);
                       lastSend = colorName;  
                       break;
                 case("RED"):
                       sendOscMessage(oscMapper+"red",colorName);
                       lastSend = colorName;  
                       break;
                 case("GREEN"):
                       sendOscMessage(oscMapper+"green",colorName);
                       lastSend = colorName;  
                       break;
                 case("BLUE"):
                       sendOscMessage(oscMapper+"blue",colorName);
                       lastSend = colorName;  
                       break;
                 default:
                       break;
               }
           }
       }catch(Exception e){e.printStackTrace();};
 }
}

/*Create and send an osc message to the remote destination
@param msgToSend OSC message to send to the remote destinatation
@param rgbColor selected color
@return
*/ 
void sendOscMessage(String msgToSend, String rgbColor){
  OscMessage myMessage = new OscMessage(msgToSend);
  oscP5.send(myMessage, myRemoteLocation);
  oscEvent(myMessage);
  println("COLOR: "+rgbColor+" -- OSC message: "+myMessage);
}
 
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
/* get and print the address pattern and typetag of the received OscMessage */
println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag" +theOscMessage.typetag());
theOscMessage.print();
}


String colorCheck(int red, int green, int blue){
  
  
  
  if(red > 140 && green > 50 && blue <= 80)
      return "ORANGE";
  if(red > 150 && green <= 55 && blue <= 80)
      return "RED";
  if(red > 150 && green > 125 && blue > 120)
      return "PINK";
  if(red < 85 && green >= 100 && blue <= 100)
      return "GREEN";
  if(red < 70 && green < 100 && blue > 100)
      return "BLUE";
      
return "NO COLOR MATCH";
}