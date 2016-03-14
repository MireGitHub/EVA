var five = require("johnny-five"),
    potentiometer,toggleSwitch,toggleSwitch2, motion, photoresistor,onBtnPlay, onBtnPause, onBtnStop, onBtnNext,onBtnPlayVideo, ledRed1, ledRed2, ledWhite, ledGreen, ledYellow;

const INFOBEAMER_PORT = 4444;
const IP_TO_CONNECT = "127.0.0.1";

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

  five.Board().on("ready", function() {
  potentiometer = new five.Sensor({
	pin: "A0",
	freq: 250
	});
  
  // Create a new `photoresistor` hardware instance.
  photoresistor = new five.Sensor({
    pin: "A2",
    freq: 250
  });

  onBtnPlay = new five.Button(13);
  onBtnPause = new five.Button(12);
  onBtnStop = new five.Button(11);
  onBtnNext = new five.Button(10);
  toggleSwitch2 = new five.Switch(9);
  toggleSwitch = new five.Switch(8);
  motion = new five.Motion(7);
  ledRed1 = new five.Led(6);
  ledRed2 = new five.Led(2);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(4);
  ledYellow = new five.Led(3);

  var ON_IR = 0;
  var indexPot, valuePot;
  indexPot = 0;
  valuePot = 0;

  // "data" get the current reading from the potentiometer
  potentiometer.on("data", function() {
			num_effect=1
			red=0.0;
			green=0.5;
			blue=0.99;
			progress=0.01;
			versusRed=1;
			versusBlue=-1;
			versusGreen=1; 
 
				var speedMod = valuePot % 100;
				var speed = valuePot / 100;
				speed = (valuePot - speedMod) / 100;
				red=speed;
				green=1-speed;
				blue=0.5-speed;
				try{
				    var msg = {
        				address: "/activeclip/video/effect"+num_effect+"/param1/values",
						args: [red]
					};
					udpPort.send(msg); 
				    var msg = {
        				address: "/activeclip/video/effect"+num_effect+"/param1/values",
						args: [green]
					};
					udpPort.send(msg); 
				    var msg = {
        				address: "/activeclip/video/effect"+num_effect+"/param1/values",
						args: [blue]
					};
					udpPort.send(msg); 


				}catch(e){
						 console.log("Connection error");
				}
		  }
		  valuePot = this.raw;

});

/*
  var indexPhoto, valuePhoto;
  indexPhoto = 0;
  valuePhoto = 0;

 // "data" get the current reading from the potentiometer
  photoresistor.on("data", function() {

  console.log(this.raw);

  if(this.raw -5 <= valuePhoto &&  this.raw + 5 >=  valuePhoto) {
	indexPhoto += 1;
	console.log(indexPhoto);
  }
  else {
	indexPhoto = 0;
  }
  if(indexPhoto > 2  &&  indexPhoto < 7){
  
	var speedMod = valuePhoto % 100;
	var speed = valuePhoto / 100;
	speed = (valuePhoto - speedMod) / 1000;
	speed -= 0.4;
	if (speed < 0) speed = 0;

	//console.log(valuePot);
	//console.log(speed);
	//console.log(indexPot);

	try{
		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client.send('/photo/opacity/' + speed, 200, function () {
	
	         //console.log("send speed");
         	client.kill(); 
		});

		
		 var client2 = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client2.send('/photo/text/' + speed, 200, function () {
		console.log("Photoresistor: " + speed);
         	client2.kill(); 
		 });

	}catch(e){
		 console.log("Connection error");
		}
        
	
  }
  valuePhoto = this.raw;

});
    */

	/***************************************/
    // Start function		
    
    onBtnPlay.on("down", function(value){
			ledRed1.on();
			console.log("Click 13");
			try {
				var msg = {
					 address: "/layer1/clip1/connect",
						args: [1]
				};
				 });
			}catch(e){
				 console.log("Connection error");
				}
       
  });

 
	/***************************************/
    // reverce function
    /*******************************************/
    onBtnPause.on("down", function(value){
			ledWhite.on();
			console.log("Click 12");
	
			try{
				var msg = {
						address: "/activeclip/audio/position/direction",
						args: [0]
					};

					console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
					udpPort.send(msg);
						});
			}catch(e){
				 console.log("Connection error");
				}
        

  });


    // Stop function
    onBtnStop.on("down", function(value){
    ledGreen.on();
    console.log("Click 11");

	try{
	   	 var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client.send('/photo/start/2', 200, function () {
	
	         console.log("send stop");
         	 client.kill(); 
		 });


	}catch(e){
		 console.log("Connection error");
		}
       
  });



    // Next function
    onBtnNext.on("down", function(value){
    ledYellow.on();
    console.log("Click 10");
	
	try{
    		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

    		client.send('/photo/next/1', 200, function () {

         	console.log("send stop");
         	client.kill();
		 });
	}catch(e){
		 console.log("Connection error");
		}
       
  });



   // Start text info		
 
   // "open" the switch is opened
    toggleSwitch2.on("open", function() {

    console.log("open switch 2");
 	try {
    		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

    		client.send('/photo/text_info/1', 200, function () {
	         	console.log("Text info");
         		client.kill();
		 	});
	     }catch(e){
		 console.log("Connection error");
		} 
  	});   


	
    // "closed" the switch is closed
    toggleSwitch2.on("close", function() {
    console.log("closed switch 2");

	try {
    		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

    		client.send('/photo/text_info/0', 200, function () {
	         	console.log("Text info");
         		client.kill();
		 	});
	     }catch(e){
		 console.log("Connection error");
		} 
	
	});  



    // "open" the switch is opened
    toggleSwitch.on("open", function() {

    console.log("open");
    ON_IR = 1;
        
	try {
		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

		client.send('/photo/video/1', 200, function () {
         	console.log("Play video");
 		client.kill();
	 	});
     	}catch(e){
	 console.log("Connection error");
	} 	

    // "calibrated" occurs once, at the beginning of a session,
	  motion.on("calibrated", function() {
	    console.log("calibrated", Date.now());
	  });

       // "motionstart" events are fired when the "calibrated"
      // proximal area is disrupted, generally by some form of movement
      motion.on("motionstart", function() {

	try {
		if(ON_IR == 1)
		{
    			var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

    			client.send('/videolist/start/0', 200, function () {

         		console.log("Auto play");
         		client.kill(); 
		 	});
		}

	}catch(e){
		 console.log("Connection error");
		}

	
	console.log("motionstart", Date.now());

  	});
   ledRed2.on();
   });


   // "closed" the switch is closed
  toggleSwitch.on("close", function() {
    console.log("closed");
    ON_IR = 0;
  // "motionend" events are fired following a "motionstart" event
  // when no movement has occurred in X ms
  motion.on("motionend", function() {
	    console.log("motionend", Date.now());
	    
	 }); 

	ledRed2.off();

	try {
		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

		client.send('/photo/video/0', 200, function () {

		console.log("Auto play");
		client.kill(); 
		ON_IR = 0;
		 });
	}catch(e){
		 console.log("Connection error");
		}
  });


});
