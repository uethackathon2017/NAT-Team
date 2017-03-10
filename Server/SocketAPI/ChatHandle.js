var ChatHandle = function () {};

ChatHandle.prototype.attach = function (io, socket) {
    var self = this;

    socket.on('chat', function (data) {

    })

};

module['exports'] = new ChatHandle();
