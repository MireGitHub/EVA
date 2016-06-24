
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
String playlistMapper = oscMapper+"playlist/";
String lastSend ="";
int wRed; 
int wGreen; 
int wBlue; 
String notSpecified = "NO COLOR MATCH";


void setup(){
 size(200,200);
 port = new Serial(this, "/dev/ttyACM0", 9600); //remember to replace COM20 with the appropriate serial port on your computer
 f = createFont("Arial",16,true);
 oscP5 = new OscP5(this,12000);
 //myRemoteLocation = new NetAddress("156.148.33.166",5555);   //WI-FI connection
 myRemoteLocation = new NetAddress("127.0.0.1",5555);      //LAN connection
 myRemoteLocationArena = new NetAddress("156.148.72.120",7000);
}
 


void draw(){
  
background(wRed,wGreen,wBlue);
 // check for serial, and process
 while (port.available() > 0) {
       delay(1000);
       serialEvent(port.readString());
 };
 text("RGB SENSOR ",50,30);
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
           
           sendOscMessageArena(wRed+":"+ wGreen+":"+ wBlue);
           
           buff="";
           colorName = colorCheck(wRed,wGreen,wBlue);
           if(!colorName.equals(notSpecified))
               println("Color: "+ colorCheck(wRed,wGreen,wBlue) + "\tR: "+ wRed+" G: "+ wGreen+" B: "+ wBlue);
           
          if(!colorName.equals(lastSend)){
               switch(colorName){
                 
                 case("VIOLET"):
                       sendOscMessage(oscMapper+"violet",colorName);
                       sendOscMessage(playlistMapper+"1", colorName);
                       lastSend = colorName;  
                       break;
                 case("RED"):
                       sendOscMessage(oscMapper+"red",colorName);
                       sendOscMessage(playlistMapper+"2", colorName);
                       lastSend = colorName;  
                       break;
                case("OCRA"):
                       sendOscMessage(oscMapper+"ocra",colorName);
                       sendOscMessage(playlistMapper+"3", colorName);
                       lastSend = colorName;  
                       break;
                 case("BLUE"):
                       sendOscMessage(oscMapper+"blue",colorName);
                       sendOscMessage(playlistMapper+"4", colorName);
                       lastSend = colorName;  
                       break;
                 case("ORANGE"):
                       sendOscMessage(oscMapper+"orange",colorName);
                       sendOscMessage(playlistMapper+"5", colorName);
                       lastSend = colorName;  
                       break;
                 case("PINK"):
                       sendOscMessage(oscMapper+"pink",colorName);
                       sendOscMessage(playlistMapper+"6", colorName);
                       lastSend = colorName;  
                       break;
                 case("GREEN"):
                       sendOscMessage(oscMapper+"green",colorName);
                       sendOscMessage(playlistMapper+"7", colorName);
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

void sendOscMessageArena(String msgToSend){
  OscMessage myMessage = new OscMessage(msgToSend);
  oscP5.send(myMessage, myRemoteLocationArena);
  oscEvent(myMessage);
  //println("COLOR: "+rgbColor+" -- OSC message: "+myMessage);
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
  if(red > 130 && green > 80 && blue > 40)
      return "OCRA";
  if(red > 120 && green < 50 && blue >= 70)
      return "VIOLET";
      
return notSpecified;
}