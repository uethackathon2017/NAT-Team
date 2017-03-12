var Sequelize = require('sequelize');
var db = require('../config/database.js');
var sequelize = new Sequelize(db.database, db.user, db.password, db);

var Room = undefined;
module.exports.connect = function (callback) {
    Room = sequelize.define('Room', {
        room_id: {
            type: Sequelize.INTEGER,
            autoIncrement: true,
            primaryKey: true
        },
        native_user: {
            type: Sequelize.STRING
        },
        foreign_user: {
            type: Sequelize.STRING
        },
        type: {
            type: Sequelize.BOOLEAN
        }
    }, {
        timestamps: false,
        createAt: false,
        updateAt: false,
        tableName: 'room'
    });
};

exports.disconnect = function (callback) {
    sequelize.close();
};

exports.create = function (data, callback) {
    var itemAttach = Room.build(data);
    itemAttach.save().then(function (row) {
        callback(null, row);
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findAll = function (callback) {
    Room.findAll({
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

exports.findById = function (id, callback) {
    Room.findOne({
        where: {
            room_id: id
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

exports.findByUser = function (data, callback) {
    Room.findOne({
        where: {
            native_user: data.native_user,
            foreign_user: data.foreign_user
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
    Room.findOne({
        where: {room_id: data.room_id}
    }).then(function (row) {
        if (row) {
            row.update(data).then(function (r) {
                callback(null, r);
            })
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        callback(err, null);
    })
};