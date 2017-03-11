var express = require('express');
var app = express();

app.use(express.static('public'));
var server = require("http").createServer(app);
var io = require("socket.io").listen(server);

app.get('/', function(req, res) {
	res.sendFile(__dirname + "/views/index.html");
});

app.get('/client2', function(req, res) {
	res.sendFile(__dirname + "/views/client2.html");
});

var WebAPIHandler = require('./api/WebAPIHandler');
var SocketAPIHandler = require('./SocketAPI/SocketAPIHandler');

server.listen(process.env.PORT || 3000);

WebAPIHandler.init(app, express);
SocketAPIHandler.init(io);

console.log('server started on 3000');