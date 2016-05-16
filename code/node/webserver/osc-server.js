var osc=require('node-osc');
var oscServer=new osc.Server(5555,'0.0.0.0');

const INFOBEAMER_PORT = 4444;
const IP_TO_CONNECT = "127.0.0.1";
console.log("ready...");
oscServer.on("message",function(msg,info){
	console.log(msg);console.log(msg[0]);
	try {
		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
    		client.send(msg[0], 200, function () {
         	client.kill(); 
	});
		

	}catch(e){
		 console.log("Connection error");
		}
	
    }	
);
