
var request = require('request') 
var NetcatServer = require('node-netcat').server;
var server = NetcatServer(5000);
request = request.defaults({timeout: 120000})

server.on('ready', function() {
    console.log('server ready');
});

server.on('data', function(client, data) {
    console.log('server rx: ' + data + ' from ' + client);
});

server.on('client_on', function(client) {
    console.log('client on ', client);
});

server.on('client_of', function(client) {
    console.log('client off ', client);
});

server.on('error', function(err) {
    console.log(err);
});

server.on('close', function() {
    console.log('server closed');
});

server.listen();// start to listening

// get active clients
//var clients = server.getClients();

// send messages to clients  and close the connection
//Object.keys(clients).forEach(function(client) {
//    server.send(clients[client], 'received ' + data, true);
//});

// or a normal message  
//server.send(client, 'message');
