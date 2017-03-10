var Sequelize = require('sequelize');
var db = require('../config/database.js');
var sequelize = new Sequelize(db.database, db.user, db.password, db);

var User = undefined;
module.exports.connect = function (callback) {
    User = sequelize.define('User', {
        user_id: {
            type: Sequelize.INTEGER,
            primaryKey: true
        },
        phone_number: {
            type: Sequelize.STRING,
            allowNull: false
        },
        user_name: {
            type: Sequelize.STRING,
            allowNull: false
        },
        password: {
            type: Sequelize.STRING,
            allowNull: false
        },
        full_name: {
            type: Sequelize.STRING,
            allowNull: false
        },
        country_id: {
            type: Sequelize.STRING,
            allowNull: false
        },
        avatar: {
            type: Sequelize.STRING,
        },
        facebook_id: {
            type: Sequelize.STRING
        },
        point: {
            type: Sequelize.INTEGER
        },
        login_status: {
            type: Sequelize.BOOLEAN
        },
        create_at: {
            type: Sequelize.DATE
        },
        update_at: {
            type: Sequelize.DATE
        },
        birthday: {
            type: Sequelize.DATE
        }
    }, {
        timestamps: false,
        createAt: false,
        updateAt: false,
        tableName: 'user'
    });
};

exports.disconnect = function (callback) {
    sequelize.close();
};

exports.create = function (data, callback) {
    var itemAttach = User.build(data);
    itemAttach.save().then(function (row) {
        callback(null, row);
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findByUserName = function (name, callback) {
    User.findOne({
        where: {user_name: name}
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

exports.findByPhone = function (phone, callback) {
    User.findOne({
        where: {phone_number: phone}
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

exports.findByFacebookId = function (id, callback) {
    User.findOne({
        where: {facebook_id: id}
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

exports.findAll = function (callback) {
    User.findAll({
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
    User.findOne({
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
    User.findOne({
        where: {user_id: data.user_id}
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