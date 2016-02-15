

var osc = require('node-osc');

var client = new osc.Client('156.148.33.166', 4444);
client.send('/photofade/start/1', 200, function () {
  console.log("send");
  client.kill(); 
});
