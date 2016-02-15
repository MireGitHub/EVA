
var request = require('request')
request = request.defaults({timeout: 120000})

var NetcatClient = require('node-netcat').client;
var client = NetcatClient(5000, 'localhost');

client.on('open', function () {
    console.log('connect');
    client.send('this is a test' + '\n');
});

/*
client.on('input', function () {
    console.log('connect');
    client.send('INPUT- this is a test' + '\n');
});
*/
client.on('data', function (data) {
  console.log(data.toString('ascii'));
  client.send('Goodbye!!!', true);
});

client.on('error', function (err) {
  console.log(err);
});

client.on('close', function () {
  console.log('close');
});


client.start();
