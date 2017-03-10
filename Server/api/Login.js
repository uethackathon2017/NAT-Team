var _ = require('lodash');
var express = require('express');
var router = express.Router();
var user = require('../models/user');
var responseData = require('../models/responseData');

var jwt = require('jsonwebtoken');
var Const = require('../const');
var bcrypt = require('bcrypt-nodejs');
var graph = require('fbgraph');
var connfigFacebook = require('../config/facebook');

var Login = function () {
};

Login.prototype.attach = function (router) {
    var self = this;

    router.post('/', function (req, res) {
        console.log('Login');
        var data = {
            phone_number: req.body.phone_number,
            password: req.body.password,
            facebook_token: req.body.facebook_token
        };
        
        console.log(data);
        if(!data.facebook_token) {
            user.connect();
            user.findByPhone(data.phone_number, function (err, result) {
                if (err) {
                    console.log(err);
                    res.json(responseData.create(Const.successFalse, Const.msgError, Const.resLoginFail));
                }
                else {
                    if (!result) {
                        console.log('Login: Phone Number Incorrect');
                        res.json(responseData.create(Const.successFalse, Const.msgPhoneNumberIncorrect, Const.resPhoneNumIncorrect));
                    } else {
                        console.log(result.user_id)
                        bcrypt.compare(data.password, result.password, function (err, r) {
                            if (r) {
                                var token = jwt.sign(result.dataValues, Const.authenticateKey, {
                                    expiresIn: "7d"
                                });
                                user.update({user_id: result.user_id, login_status: 1}, function (err) {
                                    if (err) console.log('Login: update login_status fail');
                                });
                                var userInfo = responseData.create(Const.successTrue, Const.msgLoginSuccess, Const.resNoErrorCode, token, result.user_id);
                                userInfo.data = _.merge(userInfo.data, _.pick(result, ['user_name','full_name', 'phone_number', 'avatar']));
                                res.json(userInfo);
                            } else {
                                console.log('Login: Password incorrect');
                                res.json(responseData.create(Const.successFalse, Const.msgPasswordIncorrect, Const.resPWIncorrect));
                            }
                        });
                    }
                }
            });
        } else {
            graph.extendAccessToken({
                    "access_token":   data.facebook_token
                  , "client_id":      connfigFacebook.facebook_api_key
                  , "client_secret":  connfigFacebook.facebook_api_secret
                }, function (err) {
                    if(err) {
                        console.log(err);
                        res.json(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                    } else {
                        var query = "https://graph.facebook.com/me?access_token=" + data.facebook_token;
                        graph.get(query, function(err, resFB) {
                            if(err) {
                                console.log(err);
                                res.json(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                            } else {
                                user.connect();
                                user.findByFacebookId(resFB.id, function(err, result) {
                                    if(err) {
                                        console.log(err);
                                        res.json(responseData.create(Const.successFalse, Const.msgError, Const.resError));
                                    } else {
                                        if(result) {
                                            var token = jwt.sign(result.dataValues, Const.authenticateKey, {
                                            expiresIn: "7d"
                                            });
                                            user.update({user_id: result.user_id, login_status: 1}, function (err) {
                                                if (err) console.log('Login: update login_status fail');
                                            });
                                            var userInfo = responseData.create(Const.successTrue, Const.msgLoginSuccess, Const.resNoErrorCode, token, result.user_id);
                                            userInfo.data = _.merge(userInfo.data, _.pick(result, ['user_name','full_name', 'phone_number', 'avatar']));
                                            res.json(userInfo);
                                        } else {
                                            res.json(responseData.create(Const.successFalse, Const.msgFacebookNotSignup, Const.resFacebookNotSignup));
                                        }
                                    }
                                })
                            }
                        });
                    }
                }
            );
        }
    });
};

new Login().attach(router);
module['exports'] = router;