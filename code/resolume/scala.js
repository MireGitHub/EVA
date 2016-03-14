
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

scale=0.0;
progress=0.01;
versus=1;
// Every 10 millisec, send an OSC message to Resolume
setInterval(function() {
     
      scale = scale+versus*progress;
 
      if(scale>1){
    	versus=-1;
      };
      if(scale<progress){
    	versus=1;
      };
      
    var msg = {
        address: "/activeclip/video/scale/values",
        args: [scale]
    };

    console.log("Sending message", msg.args);
    udpPort.send(msg);
}, 100);
//udpPort.close();
