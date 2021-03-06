/* http://johnny-five.readthedocs.org/en/latest/photoresistor/  */

var five = require("johnny-five"),
  board, photoresistor, led;

board = new five.Board();

board.on("ready", function() {
  led = new five.Led(3);

  // Create a new `photoresistor` hardware instance.
  photoresistor = new five.Sensor({
    pin: "A2",
    freq: 250
  });

  // Inject the `sensor` hardware into
  // the Repl instance's context;
  // allows direct command line access
  board.repl.inject({
    pot: photoresistor
  });

  // "data" get the current reading from the photoresistor
  photoresistor.on("data", function() {
    if(this.value > 800) {    
	console.log(this.value);
        led.on();
     }
    else led.off();	
  });
});


// References
//
// http://nakkaya.com/2009/10/29/connecting-a-photoresistor-to-an-arduino/
