var five = require("johnny-five"),
    potentiometer,onBtnPlay, onBtnPause, onBtnStop, onBtnNext, ledRed1, ledRed2, ledWhite, ledGreen, ledYellow;

const INFOBEAMER_PORT = 4444;
const IP_TO_CONNECT = "127.0.0.1";

var osc = require('node-osc');

  five.Board().on("ready", function() {
  potentiometer = new five.Sensor({
	pin: "A0",
	freq: 250
	});

  onBtnPlay = new five.Button(13);
  onBtnPause = new five.Button(12);
  onBtnStop = new five.Button(11);
  onBtnNext = new five.Button(10);
  ledRed1 = new five.Led(6);
  ledRed2 = new five.Led(2);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(4);
  ledYellow = new five.Led(3);

  var indexPot, valuePot;
  indexPot = 0;
  valuePot = 0;

  // "data" get the current reading from the potentiometer
  potentiometer.on("data", function() {
  
  if(this.raw == valuePot) {
	indexPot += 1;
  }
  else {
	indexPot = 0;
  }
  if(indexPot > 2  &&  indexPot < 7){
  
	var speedMod = valuePot % 100;
	var speed = valuePot / 100;
	speed = (valuePot - speedMod) / 100;
	//console.log(valuePot);
	//console.log(speed);
	//console.log(indexPot);

	try{
		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client.send('/photo/speed/' + speed, 200, function () {
	
	         //console.log("send speed");
         	client.kill(); 
		});

		
		 var client2 = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client2.send('/photo/text/' + speed, 200, function () {
		console.log(" send text");
         	client2.kill(); 
		 });

	}catch(e){
		 console.log("Connection error");
		}
        
	
  }
  valuePot = this.raw;

});


  console.log("Before press button");
    
    // Start function		
    onBtnPlay.on("down", function(value){
    ledRed1.on();
    console.log("Click 13");

 	try {
    		var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);

    		client.send('/photo/start/1', 200, function () {

         	console.log("send play");
         	client.kill(); 
		 });
	}catch(e){
		 console.log("Connection error");
		}
       
  });

 
    // Pause function
    onBtnPause.on("down", function(value){
    ledWhite.on();
    console.log("Click 12");
	
	try{
	    	var client = new osc.Client(IP_TO_CONNECT, INFOBEAMER_PORT);
	
	    	client.send('/photo/start/0', 200, function () {

         	console.log("send pause");
         	client.kill();
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

});
