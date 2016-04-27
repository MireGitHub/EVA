

var serialport = require('serialport');
var SerialPort = serialport.SerialPort;

var port = new SerialPort('/dev/cu.usbmodem411', {
  parser: serialport.parsers.raw
});
port.on('data', function (data) {
  console.log('Data: ' + data);
});
