var Sequelize = require('sequelize');
var db = require('../config/database.js');
var sequelize = new Sequelize(db.database, db.user, db.password, db);

var Lesson = undefined;
module.exports.connect = function (callback) {
    Lesson = sequelize.define('Lesson', {
        lesson_id: {
            type: Sequelize.INTEGER,
            primaryKey: true
        },
        name: {
            type: Sequelize.STRING,
            allowNull: false
        },
        level: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        language_id: {
            type: Sequelize.INTEGER,
            allowNull: false
        },
        url: {
            type: Sequelize.STRING,
            allowNull: false
        },
        point: {
            type: Sequelize.INTEGER,
            allowNull: false
        }
    }, {
        timestamps: false,
        createAt: false,
        updateAt: false,
        tableName: 'lesson'
    });
};

exports.disconnect = function (callback) {
    sequelize.close();
};

exports.create = function (data, callback) {
    var itemAttach = Lesson.build(data);
    itemAttach.save().then(function (row) {
        callback(null, row);
    }).catch(function (err) {
        callback(err, null);
    })
};

exports.findAll = function (callback) {
    Lesson.findAll({
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
    Lesson.findOne({
        where: {
            lesson_id: id
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
    Lesson.findOne({
        where: {lesson_id: data.lesson_id}
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