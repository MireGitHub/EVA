var five = require("johnny-five"),
  fsr, led, motor;

/* http://node-ardx.org/exercises/14  */
function getRGB(hue) {
  var colors = [];
  var r = five.Fn.constrain(five.Fn.map(hue, 0, 512, 255, 0), 0, 255);
  var g = five.Fn.constrain(
        five.Fn.map(hue, 0, 512, 0, 255), 0, 255) -
      five.Fn.constrain(five.Fn.map(hue, 512, 1023, 0, 255),0,255);
  var b = five.Fn.constrain(five.Fn.map(hue, 512, 1023, 0, 255), 0, 255);
  colors[0] = r;
  colors[1] = g;
  colors[2] = b;
  return colors;
}

(new five.Board()).on("ready", function() {

    // Create a new `fsr` hardware instance.
    fsr = new five.Sensor({
      pin: "A0",
      freq: 25
    });
    
    led = new five.Led(3);
    myRGBLed = new five.Led.RGB([ 9, 10, 11 ]);

    // Attach a motor to PWM pin 5
    motor = new five.Motor({
      pin: 5
    });

   // Attach a led to PWM pin 9
   /* led = new five.Led({
        pin: 9
    }); */ 

    // Scale the sensor's value to the LED's brightness range
    fsr.scale([0, 255]).on("data", function(err, value) {
      // set the led's brightness based on force
      // applied to force sensitive resistor
      led.brightness(this.scaled);
      
     var rgbColors = getRGB(this.value);
     myRGBLed.color(rgbColors);
     //console.log("read value",this.value);
    });


    /*fsr.on("read", function( err, value ) {
    console.log("read value",this.value);
    var rgbColors = getRGB(this.value);
    myRGBLed.color(rgbColors);
  	});   */

  });
