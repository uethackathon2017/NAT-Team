var LessonHandle = function () {};
var mysql = require('mysql');
var db = require('../config/database');
var Const = require('../const');
var responseData = require('../models/responseData');
var conn;
var temp;

LessonHandle.prototype.attach = function (io, socket) {
    var self = this;

    socket.on('get-lesson', function (data) {
    	console.log('get-lesson')
    	conn = mysql.createConnection(db);
    	conn.connect();
    	conn.query('Select lesson_id, name, point, level from lesson where language_id=?', [data.language_id], function(err, result) {
    		if(err) {
    			console.log(err);
    			socket.emit('get-lesson', responseData.create(Const.successFalse, Const.msgError, Const.resError));
    		} else {
                result = JSON.stringify(result[0])
    			result = JSON.parse(result);
    			temp = responseData.create(Const.successTrue, Const.msgGetLesson, Const.resNoErrorCode);
    			temp.data = result;
    			socket.emit('get-lesson', temp);
    		}
    		conn.end();
    	});
    });
};

module['exports'] = new LessonHandle();
