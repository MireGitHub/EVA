

//Lets require/import the HTTP module
var http = require('http');
var dispatcher = require('httpdispatcher');

//Lets define a port we want to listen to
const PORT=8080; 

JSON.parse('{"p": 5,"a":2}', function(k, v) {
  console.log(k+v);
  
}); 
/*
//We need a function which handles requests and send response
function handleRequest(request, response){
    response.end('It Works!! Path Hit: ' + request.url);
}*/
function handleRequest(request, response){
    try {
        //log the request on console
        console.log("handle request "+request.url);
        //Disptach
        dispatcher.dispatch(request, response);
    } catch(err) {
        console.log(err);
    }
}
//For all your static (js/css/images/etc.) set the directory name (relative path).
//dispatcher.setStatic('resources');

//A sample GET request    
dispatcher.onGet("/page1", function(req, res) {
    console.log("onGet pag1. req="+req+" res="+res);	
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Page One');
});    


//A sample POST request
dispatcher.onPost("/post1", function(req, res) {
    console.log("onPost pag1. req="+req.body+" res="+res);
    req.on('data', function (data) {
            console.log(data);
        });

    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Got Post Data');
})

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://localhost:%s", PORT);
});