var five = require("johnny-five"),
    onButton7, onButton9, onButton8, ledRed, ledWhite, ledGreen;

  var NetcatClient=require('node-netcat').client;
client = require('node-netcat').client;
var client = NetcatClient(4444, 'localhost');

  five.Board().on("ready", function() {
  onButton8 = new five.Button(8);
  onButton9 = new five.Button(9);
  onButton7 = new five.Button(7);
  ledRed = new five.Led(2);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(3);
  
  console.log("Prima");
		
   onButton8.on("down", function(value){
    client.start();

   /*client.on('input', function () {
   client.send('slideshow\n{"filename": "boy1.png", "transition": "blend1","duration": 3}\n', true);
    client.close();  
  });   */

    /*client.on('open', function () {
    
    console.log('connect');
    client.send('slideshow\n{"filename": "cat.png", "transition": "blend1","duration": 3}\n', true);
    client.close(); 
    });  
	*/

  client.on('data', function (data) {
  console.log(data.toString('ascii'));
  client.send('slideshow\n{"filename": "cat.png", "transition": "blend1","duration": 3}\n', true);
    });
    client.close();
    ledGreen.on();
    console.log("Click 8");
  });

 

  onButton9.on("down", function(value){-
    ledWhite.on();
    console.log("Click 9");

  });

    onButton7.on("down", function(value){
    ledRed.on();
    console.log("Click 7");
  });

});
