/**
 * Created by huynd on 24/11/2016.
 */
var _ = require('lodash');

var express = require('express');
var router = express.Router();
var customer = require('../models/customer');
var responseData = require('../models/responseData');

var jwt = require('jsonwebtoken');
var Const = require('../const');
var bcrypt = require('bcrypt-nodejs');

var Login = function () {
};

Login.prototype.attach = function (router) {
    var self = this;

    router.post('/', function (req, res) {
        console.log(req.headers['x-access-token']);
        customer.connect();

        var time = new Date();
        var data = {
            phone_number: req.body.phone_number,
            password: req.body.password,
            last_login: time,
            social_id: req.body.social_id
        };

        console.log('Login Customer');
        console.log(data);
        customer.findByPhone(data.phone_number, function (err, result) {
            if (err) {
                console.log('Login Customer: Login Fail');
                console.log(err);
                res.json(responseData.create(Const.successFalse, Const.msgError, Const.resLoginFail));
            }
            else {
                if (!result) {
                    console.log('Login Customer: Phone Number Incorrect');
                    res.json(responseData.create(Const.successFalse, Const.msgPhoneNumberIncorrect, Const.resPhoneNumIncorrect));
                } else {
                    if (!result.verified) {
                        console.log('Login Customer: Not verify');
                        var resData = responseData.create(Const.successFalse, Const.msgNotVerify, Const.resNotVerified);
                        ////send verify code
                        client.messages.create({
                            to: result.phone_number,
                            from: twilio.TWILIO_NUMBER,
                            body: result.verify_code
                        }, function (err, message) {
                            if (err) {
                                console.log(err);
                            }
                            else {
                                console.log(message.sid);
                            }
                        });
                        res.json(resData);
                    } else if (result.block) {
                        console.log('Login Customer: Blocked');
                        res.json(responseData.create(Const.successFalse, Const.msgBlocked, Const.resBlocked));
                    } else {
                        bcrypt.compare(data.password, result.password, function (err, r) {
                            if (r) {
                                result['last_login'] = new Date();
                                var token = jwt.sign(result.dataValues, Const.authenticateKey, {
                                    expiresIn: "7d"
                                });
                                data.password = result.password;
                                data.customer_id = result.customer_id;
                                data['login_status'] = true;
                                if (result.social_id) {
                                    data.social_id = result.social_id;
                                }
                                console.log(data);
                                customer.update(data, function (err, r) {
                                    if (err)
                                        console.log('Login Customer: update last_login fail');
                                    else
                                        console.log('Login Customer: update last_login success')
                                });
                                var customerInfo = responseData.create(Const.successTrue, Const.msgLoginSuccess, Const.resNoErrorCode, token, result.customer_id, result.resEmptyDriverId);
                                customerInfo.data = _.merge(customerInfo.data, _.pick(result, ['full_name', 'phone_number', 'email', 'avatar']));
                                res.json(customerInfo);
                            } else {
                                console.log('Login Customer: Password incorrect');
                                res.json(responseData.create(Const.successFalse, Const.msgPasswordIncorrect, Const.resPWIncorrect));
                            }
                        });
                    }
                }
            }
        });
    });
};

new Login().attach(router);
module['exports'] = router;