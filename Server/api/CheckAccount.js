var express = require('express');
var router = express.Router();
var random = require('randomstring');
var bcrypt = require('bcrypt-nodejs');

var responseData = require('../models/responseData');
var Const = require('../const.js');

var user = require('../models/user');

var CheckAccount = function () {
};

CheckAccount.prototype.attach = function (router) {
    var self = this;

    router.post('/', function (req, res) {
        console.log('CheckAccount');
        user.connect();

        var data = {
            phone_number: req.body.phone_number,
            user_name: req.body.user_name
        };

        user.findByPhone(data.phone_number, function (err, result) {
            if (err) {
                console.log(err);
                res.json(responseData.create(Const.successFalse, Const.msgCheckAccountFail, Const.resError));
            } else {
                if (result) {
                    console.log('Trung sdt');
                    res.json(responseData.create(Const.successFalse, Const.msgDuplicatePhoneNumber, Const.resDuplicatePhoneNumber));
                } else {
                    user.findByUserName(data.user_name, function (err, result) {
                        if (err) {
                            console.log(err);
                            res.json(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                        } else {
                            if (result) {
                                console.log('Trung user name');
                                res.json(responseData.create(Const.successFalse, Const.msgDuplicateUsername, Const.resDuplicateUsername));
                            } else {
                                console.log('Check account success');
                                res.json(responseData.create(Const.successTrue, Const.msgCheckAccountSuccess, Const.resNoErrorCode))
                            }
                        }
                    })
                }
            }
        });

    });


};

new CheckAccount().attach(router);
module['exports'] = router;