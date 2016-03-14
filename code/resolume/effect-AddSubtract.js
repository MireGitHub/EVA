
var osc = require("osc");

var udpPort = new osc.UDPPort({
    localAddress: "127.0.0.1",
    localPort: 57121,

    // This is where sclang is listening for OSC messages.
    remoteAddress: "127.0.0.1",
    remotePort: 7000
});

// Open the socket.
udpPort.open();

// Si assume che l' effetto AddSubtract sia il primo. 
//Cambiare il parametro num_effect in base alla posizione dell effetto 
num_effect=1
red=0.0;
green=0.5;
blue=0.99;
progress=0.01;
versusRed=1;
versusBlue=-1;
versusGreen=1;
// Every 10 millisec, send an OSC message to Resolume
setInterval(function() {
     
      red = red+versusRed*progress;
 
      if(red>1){
    	versusRed=-1;
      };
      if(red<progress){
    	versusRed=1;
      };
      
    var msg = {
        address: "/activeclip/video/effect"+num_effect+"/param1/values",
        args: [red]
    };

    console.log("Sending message red", msg.args);
    udpPort.send(msg);
}, 20);

setInterval(function() {
     
      green = green+versusGreen*progress;
 
      if(green >1){
    	versusGreen=-1;
      };
      if(green<progress){
    	versusGreen=1;
      };
      
    var msg = {
        address: "/activeclip/video/effect"+num_effect+"/param2/values",
        args: [green]
    };

    console.log("Sending message green", msg.args);
    udpPort.send(msg);
}, 100);


setInterval(function() {
     
      blue = blue+versusBlue*progress;
 
      if(blue >1){
    	versusBlue=-1;
      };
      if(blue<progress){
    	versusBlue=1;
      };
      
    var msg = {
        address: "/activeclip/video/effect"+num_effect+"/param3/values",
        args: [blue]
    };

    console.log("Sending message blue", msg.args);
    udpPort.send(msg);
}, 10);


//udpPort.close();
