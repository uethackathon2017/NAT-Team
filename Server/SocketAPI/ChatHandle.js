var mysql = require('mysql');
var db = require('../config/database');
var responseData = require('../models/responseData');
var Const = require('../const');
var chatMessage = require('../models/chat_message');
var fs = require('fs');
var imageURL = require('../config/imageURL');
var conn;
var rooms;

var ChatHandle = function () {
};

ChatHandle.prototype.attach = function (io, socket) {
    var self = this;

    socket.on('chat-history', function (data) {
        console.log('chat-history');
        conn = mysql.createConnection(db);
        conn.connect();

        conn.query('call getHistory(?, ?)', [data.room_id, data.page], function (err, result) {
            if (err) {
                console.log(err);
                socket.emit('chat-history', responseData.create(Const.successFalse, Const.msgError, Const.resError));
            } else {
                result = JSON.parse(JSON.stringify(result[0]));
                var resData = responseData.create(Const.successTrue, Const.msgGetHistory, Const.resNoErrorCode);
                resData.data.history = result;
                socket.emit('chat-history', resData);
            }
            conn.end()
        })
    });

    socket.on('send-message', function (data, callback) {
        console.log('send-message');
        var item = {
            room_id: data.room_id,
            user_id: data.user_id,
            create_at: new Date()
        };
        chatMessage.connect();
        if (data.message) { //message
            item.message = data.message;
            chatMessage.create(item, function (err) {
                if (err) {
                    console.log(err);
                    callback(false);
                } else {
                    var temp = responseData.create(Const.successTrue, Const.msgSendMessage, Const.resNoErrorCode);
                    temp.data = {
                        room_id: data.room_id,
                        sender: data.user_id,
                        time: item.create_at.toISOString().replace(/T/, ' ').replace(/\..+/, ''),
                        message: data.message
                    };
                    console.log(temp);
                    socket.to(data.room_id).emit('send-message', temp);
                    callback(true);
                }
            });
        }

        if (data.image) { //image
            var name = getAvatarName(data.user_id);
            fs.writeFile("./public/image/user/" + name, data.image, function (err) {
                if (err) {
                    console.log(err);
                    callback(false);
                } else {
                    item.image = imageURL.user + name;
                    chatMessage.create(item, function (err) {
                        if (err) {
                            console.log(err);
                            callback(false);
                        } else {
                            var temp = responseData.create(Const.successTrue, Const.msgSendMessage, Const.resNoErrorCode);
                            temp.data = {
                                room_id: data.room_id,
                                sender: data.user_id,
                                time: item.create_at.toISOString().replace(/T/, ' ').replace(/\..+/, ''),
                                image: data.image
                            };
                            console.log(temp);
                            socket.to(data.room_id).emit('send-message', temp);
                            callback(true);
                        }
                    });
                }
            });
        }
    });

    socket.on('typing', function (data, callback) {
        socket.to(data.room_id).emit('typing', '');
    });

    socket.on('call', function (data) {
        var chatMessage = require('../models/chat_message');
        chatMessage.connect();

        var item = {
            room_id: data.room_id,
            user_id: data.user_id,
            create_at: new Date()
        };

        console.log('call');
        var index = -1;
        for (var i = 0; i < clients.length; i++) {
            if (clients[i].user_id == data.other_user) {
                index = i;
                break;
            }
        }

        socket.on('cancel-call', function () {
            clients[index].emit('cancel-call', 'Cancel');
            clearTimeout(time);
            clients[index].removeAllListeners('answer');
            socket.removeAllListeners('cancel-call')

            item.call_status = 2;
            chatMessage.create(item, function (err) {
                if (err) console.log(err);
            });
        });

        clients[index].emit('call', data, function () {

        });

        clients[index].on('answer', function (dataAnswer, cbAnswer) {
            if (cbAnswer) cbAnswer(1);
            if (dataAnswer.accept) {
                socket.emit('call', responseData.create(Const.successTrue, Const.msgAcceptCall, Const.resNoErrorCode));

                item.call_status = 1;
                chatMessage.create(item, function (err) {
                    if (err) console.log(err);
                });
            } else {
                socket.emit('call', responseData.create(Const.successFalse, Const.msgDelineCall, Const.resDeclineCall));

                item.call_status = 3;
                chatMessage.create(item, function (err) {
                    if (err) console.log(err);
                });
            }
            clearTimeout(time);
            clients[index].removeAllListeners('cancel-call');
            clients[index].removeAllListeners('answer')
        });
        var time = setTimeout(function () {
            clients[index].removeAllListeners('answer');
            socket.removeAllListeners('cancel-call');
            socket.emit('call', responseData.create(Const.successFalse, Const.msgTimeoutCall, Const.resTimeotCall));

            item.call_status = 2;
            chatMessage.create(item, function (err) {
                if (err) console.log(err);
            });
        }, 20000);
    });

    socket.on('end-call', function (data) {
        socket.to(data.room_id).emit('end-call', {room_id: data.room_id})
    });

    function getAvatarName(id) {
        var name = new Date().getTime() + id + ".png";

        return name;
    }

};

module['exports'] = new ChatHandle();
