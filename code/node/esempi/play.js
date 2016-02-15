var five  = require('johnny-five');
var $ = require('jquery');

var http = require('http');
var options = {
    host: 'http://156.148.33.166',
    port: 80,
    path: '/jPlayer-2.9.2/examples/pink.flag/demo-02.html'
};

var html = '';

//var five = require("johnny-five"),
  var   onButton, onButton10, led, ledWhite;
five.Board().on("ready", function() {
  onButton = new five.Button(9);
 onButton10 = new five.Button(10);
  led = new five.Led(6);
ledWhite = new five.Led(3);




http.get(options, function(res) {
    res.on('data', function(data) {
        // collect the data chunks to the variable named "html"
        html += data;
    }).on('end', function() {
        // the whole of webpage data has been collected. parsing time!
        var title = $(html).find('btn-play').click();
        console.log(title);
     });
});





  console.log("Prima");
  onButton.on("down", function(value){
	document.getElementById("btn-play").click();
    led.on();
	http.get(options, function(res) {
    res.on('data', function(data) {
        // collect the data chunks to the variable named "html"
        html += data;
    }).on('end', function() {
        // the whole of webpage data has been collected. parsing time!
        var title = $(html).find('btn-play').click();
        console.log(title);
     });
});
    $(html).find('btn-play').click();
    console.log("Click 9");
  });

    onButton10.on("down", function(value){
    ledWhite.on();
   $(html).find('btn-play').click();
    console.log("Click 10");
  });

});