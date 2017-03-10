var express = require('express');
var router = express.Router();
var user = require('../models/user');
var responseData = require('../models/responseData');
var random = require('randomstring');

var Const = require('../const.js');
var bcrypt = require('bcrypt-nodejs');

var Register = function () {
};

Register.prototype.attach = function (router) {
    var self = this;

    router.post('/', function (req, res) {
        console.log('Register');
        user.connect();

        var data = {
            user_id: random.generate(10),
            phone_number: req.body.phone_number,
            user_name: req.body.user_name,
            password: req.body.password,
            full_name: req.body.full_name,
            facebook_token: req.body.facebook_token,
            country_id: req.body.country_id,
        };

        console.log(data);
        if(data.password) {
            bcrypt.genSalt(10, function (err, salt) {
                bcrypt.hash(data.password, salt, null, function (err, hash) {
                    if (err) {
                        console.log(err);
                        res.json(responseData.create(Const.successFalse, Const.msgRegisterFail, Const.resError));
                    } else {
                        data.password = hash;
                        user.findByPhone(data.phone_number, function (err, result) {
                            if (err) {
                                console.log(err);
                                res.json(responseData.create(Const.successFalse, Const.msgRegisterFail, Const.resError));
                            } else {
                                if (result) {
                                    console.log(Const.msgDuplicatePhoneNumber);
                                    res.json(responseData.create(Const.successFalse, Const.msgDuplicatePhoneNumber, Const.resDuplicatePhoneNumber));
                                } else {
                                    user.create(data, function (err, r) {
                                        if (err) {
                                            console.log(err);
                                            res.json(responseData.create(Const.successFalse, Const.msgRegisterFail, Const.resError));
                                        } else {
                                            console.log(Const.msgRegisterSuccess);
                                            res.json(responseData.create(Const.successTrue, Const.msgRegisterSuccess));
                                        }
                                    });
                                }
                            }
                        });
                    }
                })
            });
        }
    });

	router.post('/check-username', function (req, res) {
        console.log('check username');
        user.connect();

        user.findByUserName(req.body.user_name, function (err, result) {
            if (err) {
                console.log(err);
                res.json(responseData.create(Const.successFalse, Const.msgRegisterFail, Const.resError));
            } else {
                if (result) {
                    console.log(Const.msgDuplicatePhoneNumber);
                    res.json(responseData.create(Const.successFalse, Const.msgDuplicatePhoneNumber, Const.resDuplicatePhoneNumber));
                } else {
                    user.create(data, function (err, r) {
                        if (err) {
                            console.log(err);
                            res.json(responseData.create(Const.successFalse, Const.msgRegisterFail, Const.resError));
                        } else {
                            console.log(Const.msgRegisterSuccess);
                            res.json(responseData.create(Const.successTrue, Const.msgRegisterSuccess));
                        }
                    });
                }
            }
        });
    });
};

new Register().attach(router);
module['exports'] = router;