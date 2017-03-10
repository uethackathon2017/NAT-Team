var Sequelize = require('sequelize');
var db = require('../config/database.js');
var sequelize = new Sequelize(db.database, db.user, db.password, db);

var ChatMessage = undefined;
module.exports.connect = function (callback) {
    ChatMessage = sequelize.define('ChatMessage', {
        chat_message_id: {
            type: Sequelize.INTEGER,
            primaryKey: true
        },
        chat_id: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        user_id: {
            type: Sequelize.STRING,
            allowNull: false
        },
        message: {
            type: Sequelize.STRING,
        },
        image: {
            type: Sequelize.STRING,
        },
        delected: {
            type: Sequelize.BOOLEAN
        },
        create_at: {
            type: Sequelize.DATE
        }
    }, {
        timestamps: false,
        createAt: false,
        updateAt: false,
        tableName: 'chat_message'
    });
};

exports.disconnect = function (callback) {
    sequelize.close();
};

exports.create = function (data, callback) {
    var itemAttach = ChatMessage.build(data);
    itemAttach.save().then(function (row) {
        callback(null, row);
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findAll = function (callback) {
    ChatMessage.findAll({
        where: {}
    }).then(function (rows) {
        if (rows) {
            callback(null, rows);
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        if (err) callback(err, null);
    })
};

exports.findById = function (id, callback) {
    Customer.findOne({
        where: {
            chat_message_id: id
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

exports.findByUserId = function (id, callback) {
    Customer.findOne({
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
    ChatMessage.findOne({
        where: {chat_message_id: data.chat_message_id}
    }).then(function (row) {
        if (row) {
            row.update(data).then(function (r) {
                callback(null, r);
            }
        } else {
            callback(null, null);
        }
    }).catch(function (err) {
        callback(err, null);
    })
};