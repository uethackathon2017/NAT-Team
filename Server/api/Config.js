var express = require("express");
var router = express.Router();
var async = require("async");

var responseData = require("../models/responseData");
var Const = require("../const");

var db = require("../config/database");
var mysql = require("mysql");

var Config = function () {
};

Config.prototype.attach = function (router) {
    var self = this;

    router.post("/", function (req, res) {
        var conn = mysql.createConnection(db);
        conn.connect();

        var userId = req.body.user_id;
        var resData = responseData.create(Const.successTrue, Const.msgConfig, Const.resNoErrorCode);
        resData.data = {};


        async.parallel([
            function (sendOut) {
                conn.query('SELECT * FROM country', function (err, rows) {
                    if (err) {
                        console.log("err: " + err);
                        return sendOut(err);
                    } else {
                        sendOut(null, rows);
                    }
                })
            },

            function (sendOut) {
                conn.query('SELECT * FROM language', function (err1, rows1) {
                    if (err1) {
                        console.log("err1: " + err1);
                        return sendOut(err1);
                    } else {
                        sendOut(null, rows1);
                    }
                })
            }
        ], function (errorAsync, configInfo) {
            if (errorAsync) {
                console.log('error async: ' + errorAsync);
                res.json(responseData.create(Const.successFalse, Const.msgConfigError, Const.resError));
            }
            else {
                resData.data.country = configInfo[0];
                resData.data.language = configInfo[1];
                console.log('Sent config');
                res.json(resData);
            }

            conn.end();
        });
    })
};

new Config().attach(router);
module["exports"] = router;
