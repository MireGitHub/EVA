var five = require("johnny-five"), led;
var board = new five.Board();

board.on("ready", function() {

  led = new five.Led(2);

  // Create a new `motion` hardware instance.
  var motion = new five.Motion(7);
 
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

  // "motionend" events are fired following a "motionstart" event
  // when no movement has occurred in X ms
  motion.on("motionend", function() {
    console.log("motionend", Date.now());
    led.off();
  });
});

