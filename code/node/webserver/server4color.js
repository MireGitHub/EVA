var osc=require('node-osc');
var sosc=require('osc');
var oscServer=new osc.Server(5555,'0.0.0.0');

const QLC_PORT = 7700;
const IP_TO_CONNECT = "127.0.0.1";

var udpPort = new sosc.UDPPort({
    localAddress: "127.0.0.1",
    localPort: 5556,

    // This is where sclang is listening for OSC messages.
    remoteAddress: "127.0.0.1",
    remotePort: 7700
});
udpPort.open();

console.log("ready...");
oscServer.on("message",function(msg,info){
	console.log(msg);console.log(msg[0]);
    rgb=msg[0].split(":")
	console.log("red "+rgb[0].replace("/",""))
	console.log("green "+rgb[1])
	console.log("blue "+rgb[2])
	try {
			var redmsg = {
				address: "/2/fader4",
				args: 256-parseInt(rgb[0].replace("/",""))
			};
			udpPort.send(redmsg);

			var gmsg = {
				address: "/2/fader7",
				args: 256-parseInt(rgb[1])
			};
			udpPort.send(gmsg);

			var bmsg = {
				address: "/2/fader5",
				args: 256-parseInt(rgb[2])
			};
			udpPort.send(bmsg);


		/*
		var client = new osc.Client(IP_TO_CONNECT, QLC_PORT);
    		client.send("/2/fader4/"+rgb[0].replace("/",""), 200, function () {
         		console.log("RED "+"/2/fader4/"+rgb[0].replace("/",""));
			client.kill(); 
		});
		*/

	}catch(e){
		 console.log("Connection error");
		}
	
    }	
);
