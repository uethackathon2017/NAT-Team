var RoomHandle = function () {};
var mysql = require('mysql');
var db = require('../config/database');
var Const = require('../const');
var responseData = require('../models/responseData');
var conn;
var rooms;

RoomHandle.prototype.attach = function (io, socket) {
    var self = this;

    socket.on('get-all-room', function (data) {
    	conn = mysql.createConnection(db);
    	conn.connect();
    	conn.query('call getNativeRoom(?)', [data.user_id], function(err, nativeRoom) {
    		if(err) {
    			console.log(err);
    			socket.emit('get-all-room', responseData.create(Const.successFalse, Const.msgError, Const.resError));
    		} else {
    			conn.query('call getForeignRoom(?)', [data.user_id], function(err, foreignRoom) {
		    		if(err) {
		    			console.log(err);
		    			socket.emit('get-all-room', responseData.create(Const.successFalse, Const.msgError, Const.resError));
		    		} else {
		    			nativeRoom = JSON.stringify(nativeRoom[0]);
                    	nativeRoom = JSON.parse(nativeRoom);
                    	foreignRoom = JSON.stringify(foreignRoom[0]);
                    	foreignRoom = JSON.parse(foreignRoom);
		    			var resData = responseData.create(Const.successTrue, Const.msgGetRoom, Const.resNoErrorCode);
		    			resData.data = {
		    				native_room: nativeRoom,
		    				foreign_room: foreignRoom,
		    			};
		    			socket.emit('get-all-room', resData);
		    		}
                    conn.end();
		    	})
    		}
    	})
    });

    socket.on('get-random-room', function (data) {
        conn = mysql.createConnection(db);
        conn.connect();
        conn.query('call getRandomRoom(?)', [data.user_id], function(err, result) {
            if(err) {
                console.log(err);
                socket.emit('get-random-room', responseData.create(Const.successFalse, Const.msgError, Const.resError));
            } else {
                var resData = responseData.create(Const.successTrue, Const.msgGetRoom, Const.resNoErrorCode);
                resData.data = {
                    random: JSON.parse(JSON.stringify(result[0]))
                };
                socket.emit('get-random-room', resData);
            }
        })
    })

};

module['exports'] = new RoomHandle();
