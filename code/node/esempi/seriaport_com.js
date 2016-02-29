/*var SerialPort = require("serialport").SerialPort;
var serialport = new SerialPort("/dev/ttyACM0");

serialport.on('open', function(){
  console.log('Serial Port Opend');
  serialport.on('data', function(data){
      console.log(data[0]);
  });
});   */


http = require('http');
fs = require('fs');
serialport = require('serialport');

port = 3000;
host = '127.0.0.1';
SerialPort = serialport.SerialPort;
arduinoPort = '/dev/ttyACM0';

var printLog = true;
var playerRoundKills = 0;
var playerTotalKills;
var roundLive = false;

//open port
var myPort = new SerialPort(arduinoPort);
parser: serialport.parsers.raw          
serialport.on('open', function(){
  console.log('Serial Port Opend');
  serialport.on('data', function(data){
      console.log(data[0]);
  });
});

//implementation of abstract port functions
myPort.on('open', showPortOpen);
myPort.on('data', sendSerialData);
myPort.on('close', showPortClose);
myPort.on('error', showError);

function showPortOpen() {
   console.log('port open. Data rate: ' + myPort.options.baudRate);
}

//output incoming data
function sendSerialData(data) {
   console.log(data[0]);
if(typeof data[1] !== 'undefined') console.log(data[1]);
}

function showPortClose() {
   console.log('port closed.');
}

function showError(error) {
   console.log('Serial port error: ' + error);
}

myPort.on("open", function () {
  console.log('open');
//send data (3) to arduino
myPort.write(3, function(err, results) {
    if(err != null)console.log('Error first send: ' + err);
    if(results != null)console.log("First send: "+results);
  });
});

