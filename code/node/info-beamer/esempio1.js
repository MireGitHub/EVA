
var NetcatClient = require('node-netcat').client;
var client = NetcatClient(4444, '156.148.33.166');

client.on('open', function () {
    console.log('connect');
    client.send('slideshow\n{"filename": "boy1.png", "transition": "blend1"}\n');
});
/*
client.on('data', function (data) {
  console.log(data.toString('ascii'));
  client.send('Goodbye!!!', true);
});
*/

client.on('error', function (err) {
  console.log(err);
});

client.on('close', function () {
  console.log('close');
});

client.start();
