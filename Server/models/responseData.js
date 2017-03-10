var responseData = {};

exports.create = function(success, message, error_code, token, user_id) {
    responseData =  {
        "success": success,
        "message": message,
        "error_code": error_code,
        "data": {
            "token": token,
            "user_id": user_id
        }
    };
    return responseData;
};

exports.coordinates = function(success, message, list) {
    responseData = {
        "success": success,
        "message": message,
        "data" : {
            "list": list
        }
    };
    return responseData;
};