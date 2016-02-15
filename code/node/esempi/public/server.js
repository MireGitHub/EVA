// server.js
var express        = require('express');  
var app            = express();  
var httpServer = require("http").createServer(app);  
var five = require("johnny-five");  
var io=require('socket.io')(httpServer);
 
var port = 3000; 
var  onButton10, onButton9, onButton8, ledRed, ledWhite, ledGreen;

app.use(express.static(__dirname + '/public'));
 
app.get('/', function(req, res) {  
        res.sendFile(__dirname + '/public/index.html');
});
 
httpServer.listen(port);  
console.log('Server available at http://localhost:' + port);  
var led;
 
//Arduino board connection
 
var board = new five.Board();  
board.on("ready", function() {  
    console.log('Arduino connected');
    led = new five.Led(2);
  onButton8 = new five.Button(8);
  onButton9 = new five.Button(9);
  onButton10 = new five.Button(10);
  ledRed = new five.Led(6);
  ledWhite = new five.Led(5);
  ledGreen = new five.Led(3);
});


 

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

//Socket connection handler
io.on('connection', function (socket) {  
        console.log(socket.id);
 
        socket.on('led:on', function (data) {
           led.on();
           console.log('LED ON RECEIVED');
        });
 
        socket.on('led:off', function (data) {
            led.off();
            console.log('LED OFF RECEIVED');
 
        });
    });
 
console.log('Waiting for connection');
 