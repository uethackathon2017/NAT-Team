var mysql = require('mysql');
var db = require('../config/database');
var responseData = require('../models/responseData');
var Const = require('../const');
var chatMessage = require('../models/chat_message');
var fs = require('fs');
var imageURL = require('../config/imageURL');
var user = require('../models/user');
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

    socket.on('create-room', function (data, callback) {
        console.log('create-room');
        if(callback) {
            var room = require('../models/room');
            var item = {
                native_user: data.other_user,
                foreign_user: socket.user_id
            }
            var temp;
            room.connect();
            room.findByUser(item, function(err, result) {
                if(err) {
                    console.log(err);
                    callback(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                } else {
                    if(result) {
                        temp = responseData.create(Const.successTrue, Const.msgCreateRoom, Const.resNoErrorCode);
                        temp.data = {
                            room_id: result.room_id
                        }
                        socket.join(temp.data.room_id);
                        for(var i=0; i<clients.length; i++) {
                            if(clients[i].user_id == item.native_user){
                                clients[i].join(temp.data.room_id);
                                break;
                            }
                        }
                        callback(temp);
                    } else {
                        conn = mysql.createConnection(db);
                        conn.connect();
                        conn.query('Insert into room set native_user=?, foreign_user=?', [item.native_user, item.foreign_user], function(err, r){
                            if(err) {
                                console.log(err);
                                callback(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                            } else {
                                temp = responseData.create(Const.successTrue, Const.msgCreateRoom, Const.resNoErrorCode);
                                temp.data = {
                                    room_id: r['insertId']
                                }
                                socket.join(temp.data.room_id);
                                for(var i=0; i<clients.length; i++) {
                                    if(clients[i].user_id == item.native_user){
                                        clients[i].join(temp.data.room_id);
                                        break;
                                    }
                                }
                                callback(temp);
                            }
                            conn.end();
                        })
                    }
                }
            });
        }
    });

    socket.on('send-message', function (data, callback) {
        console.log('send-message');
        var item = {
            room_id: data.room_id,
            user_id: data.user_id,
            create_at: new Date()
        };
        var user = require('../models/user');
        user.connect();
        user.findById(socket.user_id, function(err, dataUser) {
            if(err) {
                console.log(err);
                callback(false);
            } else {
                if (data.message) { //message
                    item.message = data.message;
                    chatMessage.connect();
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
                                message: data.message,
                                avatar: dataUser.avatar,
                                full_name: dataUser.full_name
                            };
                            console.log(temp);
                            socket.to(data.room_id).emit('send-message', temp);
                            callback(true);
                        }
                    });
                }

                if (data.image) { //image
                    var name = getAvatarName(data.user_id);
                    fs.writeFile("./public/image/user/" + name, data.image, 'base64', function (err) {
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
                                        image: item.image
                                    };
                                    socket.to(data.room_id).emit('send-message', temp);
                                    callback(true);
                                }
                            });
                        }
                    });
                }
            }
        })
    });

    socket.on('typing', function (data, callback) {
        socket.to(data.room_id).emit('typing', '');
    });

    socket.on('call', function (data, cbCall) {
        console.log('call');
        if(cbCall) cbCall(1);
        console.log(data);
        var chatMessage = require('../models/chat_message');
        chatMessage.connect();

        var item = {
            room_id: data.room_id,
            user_id: socket.user_id,
            create_at: new Date()
        };
        var receiverSocket = 0;
        for (var i = 0; i < clients.length; i++) {
            if (clients[i].user_id == data.receiver_id) {
                receiverSocket = clients[i];
                break;
            }
        }

        if(!receiverSocket) {
            socket.emit('answer', responseData.create(Const.successFalse, Const.msgReceiverNotFound, Const.resReceiverNotFound));
        } else {
            user.connect();
            user.findById(socket.user_id, function(err, dataUser) {
                if(err) {
                    console.log(err);
                    socket.emit('answer', responseData.create(Const.successFalse, Const.msgError, Const.resError));
                } else {
                    console.log("tim thay ne: " + receiverSocket.user_id);
                    socket.on('cancel-call', function () {
                        receiverSocket.emit('cancel-call', 'Cancel');
                        clearTimeout(time);
                        receiverSocket.removeAllListeners('answer');
                        socket.removeAllListeners('cancel-call')

                        item.call_status = 2;
                        chatMessage.create(item, function (err) {
                            if (err) console.log(err);
                        });
                    });
                    // send data user
                    var dataSender = responseData.create(Const.successTrue, Const.msgCall, Const.resNoErrorCode);
                    dataSender.data = {
                        "room_id": data.room_id,
                        "sender": socket.user_id,
                        "hasVideo": data.hasVideo,
                        "avatar": dataUser.avatar,
                        "full_name": dataUser.full_name,
                        "call_id": data.call_id
                    }
                    receiverSocket.emit('call', dataSender, function () {

                    });

                    receiverSocket.on('answer', function (dataAnswer, cbAnswer) {
                        if (cbAnswer) cbAnswer(1);
                        if (dataAnswer.accept) {
                            socket.emit('answer', responseData.create(Const.successTrue, Const.msgAcceptCall, Const.resNoErrorCode));
                            item.call_status = 1;
                            chatMessage.create(item, function (err) {
                                if (err) console.log(err);
                            });
                        } else {
                            socket.emit('answer', responseData.create(Const.successFalse, Const.msgDelineCall, Const.resDeclineCall));

                            item.call_status = 3;
                            chatMessage.create(item, function (err) {
                                if (err) console.log(err);
                            });
                        }
                        clearTimeout(time);
                        socket.removeAllListeners('cancel-call');
                        receiverSocket.removeAllListeners('answer')
                    });
                    var time = setTimeout(function () {
                        receiverSocket.removeAllListeners('answer');
                        socket.removeAllListeners('cancel-call');
                        socket.emit('answer', responseData.create(Const.successFalse, Const.msgTimeoutCall, Const.resTimeotCall));

                        item.call_status = 2;
                        chatMessage.create(item, function (err) {
                            if (err) console.log(err);
                        });
                    }, 30000);
                }
            })
        }
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
