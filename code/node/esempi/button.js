var five = require("johnny-five"),
    onBtnPlay, onBtnPause, onBtnStop, onBtnNext, ledRed1, ledRed2, ledWhite, ledGreen, ledYellow;

const INFOBEAMER_PORT = 4444;
const IP_TO_CONNECT = "127.0.0.1";

var osc = require('node-osc');

  five.Board().on("ready", function() {
  onBtnPlay = new five.Button(13);
  onBtnPause = new five.Button(12);
  onBtnStop = new five.Button(11);
  onBtnNext = new five.Button(10);
  ledRed1 = new five.Led(6);
  ledRed2 = new five.Led(2);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(4);
  ledYellow = new five.Led(3);


  console.log("Before press button");
    
    // Start function		
    onBtnPlay.on("down", function(value){
    ledRed1.on();
    console.log("Click 13");
 
    var client = new osc.Client('IP_TO_CONNECT', INFOBEAMER_PORT);

    client.send('/photo/start/1', 200, function () {

         console.log("send play");
         client.kill(); 
        });
  });

 
    // Pause function
    onBtnPause.on("down", function(value){
    ledWhite.on();
    console.log("Click 12");

  });


    // Stop function
    onBtnStop.on("down", function(value){
    ledGreen.on();
    console.log("Click 11");

    var client = new osc.Client('IP_TO_CONNECT', INFOBEAMER_PORT);

    client.send('/photo/start/2', 200, function () {

         console.log("send stop");
         client.kill(); 
        });
  });



    // Next function
    onBtnNext.on("down", function(value){
    ledYellow.on();
    console.log("Click 10");
  });

});
