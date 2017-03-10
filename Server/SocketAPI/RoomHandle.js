var RoomHandle = function () {};

RoomHandle.prototype.attach = function (io, socket) {
    var self = this;

    socket.on('get-all-room', function (data) {

    })

};

module['exports'] = new RoomHandle();
