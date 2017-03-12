var db = require('../config/database');
var mysql = require('mysql');
var Const = require('../const');
var responseData = require('../models/responseData')
global.clients = [];
var SocketApiHandler = {
    io: null,
    nsp: null,
    init: function (io) {
        var self = this;
        this.io = io;
        this.nsp = io;

        this.nsp.sockets.on('connection', function (socket) {
            console.log('New connection');

            socket.on('new-user', function (data, callback) {
                var index = isExist(data.user_id);
                var conn = mysql.createConnection(db);

                conn.connect();
                conn.query('SELECT room_id FROM room WHERE native_user=? or foreign_user=?', [data.user_id, data.user_id], function (err, result) {
                    if (err) {
                        console.log(err);
                        socket.emit('new-user', responseData.create(Const.successFalse, Const.msgError, Const.resError));
                    } else {
                        var user = require('../models/user');
                        user.connect();
                        user.update({user_id: data.user_id, login_status: 1}, function(err){
                            console.log("update login_status = 1")
                        })
                        try {
                            while (Object.keys(io.sockets.adapter.sids[socket.id]).length-1 !== result.length) {
                                for (var i = 0; i < result.length; i++) {
                                    socket.join(result[i].room_id);
                                }
                            }
                            socket.user_id = data.user_id;
                            if(index == -1) {
                                socket.status = 0;
                                clients.push(socket);
                                console.log('New User:'  + data.user_id);
                            } else {
                                clients[index].status = -1;
                                clients[index] = socket;
                                console.log('Replace User:'  + data.user_id);
                            }
                        } catch(err) {
                            console.log(err);
                            socket.disconnect(true);
                        }
                        if (callback) callback(1);
                        require('./RoomHandle').attach(io, socket);
                        require('./ChatHandle').attach(io, socket);
                        // require('./LessonHandle').attach(io, socket);
                    }
                    conn.end()
                })
            });

            socket.on('disconnect', function () {
                console.log('Disconnected: '+ socket.user_id);
                var user = require('../models/user');
                user.connect();
                user.update({user_id: socket.user_id, login_status: 0}, function(err){
                    console.log("update login_status = 0")
                })

                var index = clients.indexOf(socket);
                if (index != -1) {
                    clients.splice(index, 1);
                    console.log('clients: ' + clients.length);
                }
            })
        })

    }
};

module['exports'] = SocketApiHandler;

function isExist(id) {
    for (var i = 0; i < clients.length; i++) {
        if (id === clients[i].user_id) {
            return i;
        }
    }
    return -1;
}