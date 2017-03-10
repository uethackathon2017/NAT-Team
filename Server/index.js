var express = require('express');
var app = express();

app.use(express.static('public'));
// app.set("view engine", "ejs");
// app.set("views", "./views");
var server = require("http").createServer(app);
var io = require("socket.io").listen(server);

var WebAPIHandler = require('./api/WebAPIHandler');
// var SocketAPIHandler = require('./SocketAPI/SocketAPIHandler');

server.listen(process.env.PORT || 3000);

WebAPIHandler.init(app, express);
// SocketAPIHandler.init(io);

console.log('server started on 3000')