var Sequelize = require('sequelize');
var db = require('../config/database.js');
var sequelize = new Sequelize(db.database, db.user, db.password, db);

var UserLanguage = undefined;
module.exports.connect = function (callback) {
    UserLanguage = sequelize.define('UserLanguage', {
        user_id: {
            type: Sequelize.INTEGER,
            primaryKey: true
        },
        language_id: {
            type: Sequelize.STRING,
            primaryKey: true
        }
    }, {
        timestamps: false,
        createAt: false,
        updateAt: false,
        tableName: 'user_language'
    });
};

exports.disconnect = function (callback) {
    sequelize.close();
};

exports.create = function (data, callback) {
    var itemAttach = UserLanguage.build(data);
    itemAttach.save().then(function (row) {
        callback(null, row);
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findAll = function (callback) {
    UserLanguage.findAll({
        where: {}
    }).then(function (rows) {
        if (rows) {
            callback(null, rows);
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findByUserId = function (id, callback) {
    UserLanguage.findOne({
        where: {
            user_id: id
        }
    }).then(function (row) {
        if (row) {
            callback(null, row);
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.update = function (data, callback) {
    UserLanguage.findOne({
        where: {user_id: data.user_id}
    }).then(function (row) {
        if (row) {
            row.update(data).then(function (r) {
                callback(null, r);
            });
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        callback(err, null);
    })
};