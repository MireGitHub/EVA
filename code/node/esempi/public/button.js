var five = require("johnny-five"),
    onButton10, onButton9, onButton8, ledRed, ledWhite, ledGreen;
  
  five.Board().on("ready", function() {
  onButton8 = new five.Button(8);
  onButton9 = new five.Button(9);
  onButton10 = new five.Button(10);
  ledRed = new five.Led(6);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(3);

  console.log("Prima");

   onButton8.on("down", function(value){
    ledGreen.on();
    console.log("Click 8");
  });

  onButton9.on("down", function(value){
    ledWhite.on();
    console.log("Click 9");
  });

    onButton10.on("down", function(value){
    ledRed.on();
    console.log("Click 10");
  });

});
