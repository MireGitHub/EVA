var five = require("johnny-five"),
  board, toggleSwitch, led;

board = new five.Board();

board.on("ready", function() {

// Create a new `motion` hardware instance.
  var motion = new five.Motion(7);
  led = new five.Led(2);
 

  // Create a new `switch` hardware instance.
  // This example allows the switch module to
  // create a completely default instance
  toggleSwitch = new five.Switch(8);

  // Inject the `switch` hardware into
  // the Repl instance's context;
  // allows direct command line access
  board.repl.inject({
    toggleSwitch: toggleSwitch
  });

  // Switch Event API

  // "closed" the switch is closed
  toggleSwitch.on("close", function() {
    console.log("closed");
	
  // "motionend" events are fired following a "motionstart" event
  // when no movement has occurred in X ms
  motion.on("motionend", function() {
	    console.log("motionend", Date.now());
	    led.off();
	  });
  });


  // "open" the switch is opened
  toggleSwitch.on("open", function() {
    console.log("open");

	 // "calibrated" occurs once, at the beginning of a session,
	  motion.on("calibrated", function() {
	    console.log("calibrated", Date.now());
	  });

       // "motionstart" events are fired when the "calibrated"
      // proximal area is disrupted, generally by some form of movement
      motion.on("motionstart", function() {
	    led.on();
	    console.log("motionstart", Date.now());
  	});
  });

});
