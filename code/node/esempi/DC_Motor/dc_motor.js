var five = require("johnny-five"), 
    board = new five.Board();

var configs = five.Motor.SHIELD_CONFIGS.ARDUINO_MOTOR_SHIELD_R3_1;

var motorA = new five.Motor(configs.A);
var motorB = new five.Motor(configs.B);

board.on("ready", function() {

  var motor = new five.Motor(5);

  // Start the motor at maximum speed
  motor.start(255);

});
