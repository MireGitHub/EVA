

//Lets require/import the HTTP module
var http = require('http');
var dispatcher = require('httpdispatcher');
var osc = require("osc");

var udpPort = new osc.UDPPort({
    localAddress: "127.0.0.1",
    localPort: 57121,

    // This is where sclang is listening for OSC messages.
    remoteAddress: "127.0.0.1",
    remotePort: 7000
});
//Lets define a port we want to listen to
const PORT=8080; 

//JSON.parse('{"p": 5,"a":2}', function(k, v) {
//  console.log(k+v);
  
//}); 
/*
//We need a function which handles requests and send response
function handleRequest(request, response){
    response.end('It Works!! Path Hit: ' + request.url);
}*/
function handleRequest(request, response){
    try {
        //log the request on console
        console.log("handle request "+request.url);
        //Disptach
        dispatcher.dispatch(request, response);
    } catch(err) {
        console.log(err);
    }
}
//For all your static (js/css/images/etc.) set the directory name (relative path).
//dispatcher.setStatic('resources');

//A sample GET request    
dispatcher.onGet("/page1", function(req, res) {
    console.log("onGet pag1. req="+req+" res="+res);	
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Page One');
});    


//A sample POST request
dispatcher.onPost("/post1", function(req, res) {
	var state=0;
	var index=0;
    console.log("onPost pag1. req="+req.body+" res="+res);
    req.on('data', function (data) {
            console.log(data);
        });
	JSON.parse(req.body, function(k, v) {
	  console.log(k+v);
	  if(k=="state"){state=parseInt(v)};
	  if(k=="index"){index=parseInt(v)};
	  
	}); 
	if(index==0){
		if(state==1){
			var msg = {
				address: "/layer1/clip1/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer1/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }
    if(index==1){
    	if(state==1){
			var msg = {
				address: "/layer1/clip2/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer1/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
		
    } 
    if(index==2){
    	if(state==1){
			var msg = {
				address: "/layer1/clip3/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer1/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
     }
    if(index==3){
    	if(state==1){
			var msg = {
				address: "/layer1/clip4/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer1/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }
    
    if(index==4){
    	if(state==1){
			var msg = {
				address: "/layer2/clip1/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer2/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }
    if(index==5){
    	if(state==1){
			var msg = {
				address: "/layer2/clip2/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer2/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }
    if(index==6){
    	if(state==1){
			var msg = {
				address: "/layer2/clip3/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer2/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }
    if(index==7){
    	if(state==1){
			var msg = {
				address: "/layer2/clip4/connect",
				args: parseInt(1)
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    	if(state==0){
			var msg = {
				address: "/layer2/clear",
				args: 1
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
		}
    }

})// fine dispatcher
dispatcher.onPost("/postpot", function(req, res) {
	var state=0;
	var index=0;
    //console.log("onPostpot pag1. req="+req.body+" res="+res);
    req.on('data', function (data) {
            console.log(data);
        });
	JSON.parse(req.body, function(k, v) {
	  console.log(k+v);
	  if(k=="state"){state=parseInt(v)};
	  if(k=="index"){index=parseInt(v)};
	  
	}); 
 
		if(index==4){
			var msg = {
				address: "/activeclip/video/anchorx/values",
				args: (state*0.5)/512
			};
		     
			console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
			udpPort.send(msg);
       }
})
udpPort.open();

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://localhost:%s", PORT);
});
