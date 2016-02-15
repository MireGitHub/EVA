var five = require("johnny-five"),
    onButton7, onButton9, onButton8, ledRed, ledWhite, ledGreen;


var osc = require('node-osc');

  five.Board().on("ready", function() {
  onButton8 = new five.Button(11);
  onButton9 = new five.Button(9);
  onButton7 = new five.Button(10);
  ledRed = new five.Led(3);
  ledWhite = new five.Led(6);
  ledGreen = new five.Led(5);
  ledRed.off();
  ledWhite.off();
  ledGreen.off();


  console.log("Prima");
		
    onButton8.on("down", function(value){
    ledGreen.on();
    console.log("Click 11");


    var client = new osc.Client('156.148.132.240', 4444);
    client.send('/photo/start/1', 200, function () {
         console.log("send");
         client.kill(); 
        });
  });

 

  onButton9.on("down", function(value){-
    ledWhite.on();
    console.log("Click 9");

  });

    onButton7.on("down", function(value){
    ledRed.on();
    console.log("Click 10");
  });

});
