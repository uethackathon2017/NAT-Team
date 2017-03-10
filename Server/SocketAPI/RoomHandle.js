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
		    			conn.query('call getFriendRoom(?)', [data.user_id], function(err, friendRoom) {
				    		if(err) {
				    			console.log(err);
				    			socket.emit('get-all-room', responseData.create(Const.successFalse, Const.msgError, Const.resError));
				    		} else {
				    			console.log(foreignRoom)
				    			nativeRoom = JSON.stringify(nativeRoom[0]);
		                    	nativeRoom = JSON.parse(nativeRoom);
		                    	foreignRoom = JSON.stringify(foreignRoom[0]);
		                    	foreignRoom = JSON.parse(foreignRoom);
		                    	friendRoom = JSON.stringify(friendRoom[0]);
		                    	friendRoom = JSON.parse(friendRoom);
			               
			                    console.log(foreignRoom)
				    			var resData = responseData.create(Const.successTrue, Const.msgGetRoom, Const.resNoErrorCode);
				    			resData.data = {
				    				native_room: nativeRoom,
				    				foreign_room: foreignRoom,
				    				friend_room: friendRoom
				    			}
				    			socket.emit('get-all-room', resData);
				    		}
				    		conn.end();
				    	})
		    		}
		    	})
    		}
    	})
    })

};

module['exports'] = new RoomHandle();
