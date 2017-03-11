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
                conn = mysql.createConnection(db);
                conn.connect();

                conn.query('SELECT room_id FROM room WHERE (native_user || foreign_user) = ?', [data.user_id], function (err, result) {
                    if (err) {
                        console.log(err);
                        socket.emit('new-user', responseData.create(Const.successFalse, Const.msgError, Const.resError));
                    } else {
                        while (Object.keys(io.sockets.adapter.sids[socket.id]).length-1 !== result.length) {
                            for (var i = 0; i < result.length; i++) {
                                socket.join(result[i].room_id);
                            }
                        }
                        socket.user_id = data.user_id;
                        socket.status = 0;
                        clients.push(socket);
                        if (callback) callback(1);
                        require('./RoomHandle').attach(io, socket);
                        require('./ChatHandle').attach(io, socket);
                    }
                    conn.end()
                })
            });

            socket.on('disconnect', function () {
                console.log('Disconnected')
            })
        })

    }
};

module['exports'] = SocketApiHandler;
