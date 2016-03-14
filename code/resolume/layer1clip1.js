
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

// Every second, send an OSC message to SuperCollider
//setInterval(function() {
    var msg = {
        address: "/layer1/clip1/connect",
        args: [1]
    };

    console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
    udpPort.send(msg);
//}, 1000);
//udpPort.close();

    var msg = {
        address: "/activeclip/audio/position/direction",
        args: [0]
    };

    console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
    udpPort.send(msg);
