var express = require('express');
var router = express.Router();

var bodyParser = require('body-parser');

var WebAPIHandler = {
    init: function (app, express) {
        var self = this;

        app.use(bodyParser.urlencoded({ extended: true }));
        app.use(bodyParser.json());

        router.use("/check-account", require('./CheckAccount'));
        router.use("/register", require('./Register'));
        router.use("/login", require('./Login'));
        // router.use("/logout", require('./Logout'));
        router.use("/config", require('./Config'));

        WebAPIHandler.router = router;

        app.use('/api', router);
    }
};

module["exports"] = WebAPIHandler;
