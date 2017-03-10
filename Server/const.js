(function (global) {
    "use strict;"

    // Class ------------------------------------------------
    var Const = {};

    // Error code
    // success code
    Const.successTrue = 1;
    Const.successFalse = 0;

    Const.resNoErrorCode = 0;
    Const.resEmptyDriverId = '';
    Const.resEmptyCustomerId = '';

    Const.resError = 100;
    Const.resDuplicatePhoneNumber = 101;
    Const.resDuplicateEmail = 102;

    Const.resPhoneNumIncorrect = 110;
    Const.resVerifyNumIncorrect = 111;

    Const.resPWIncorrect = 121;
    Const.resSocialIdIncorrect = 122;
    Const.resNotVerified = 123;
    Const.resBlocked = 124;
    Const.resNotActivated = 125;

    Const.resCodeNoId = 131;


    Const.resLoggedIn = 140;
    Const.resLoginFail = 141;

    Const.resPhoneNumOrPWIncorrect = 151;

    Const.resTripNotExist = 161;

    Const.resNoHistory = 171;

    Const.resConfigIncorrectId = 180;

    Const.resNoBooking = 190;
    Const.resNotValidToken = 201;

    Const.resDriverNotFound = 150;
    Const.timeBooking = 15*1000;

    Const.authenticateKey = "server123";

    // cancel trip
    Const.resCustomerCancel = 1001;
    Const.resDriverCancel = 1002;

    // feedback
    Const.resWasFeedback = 131;
    Const.msgWasFeedback = 'Journey was feedback';
    Const.msgFeedbackSuccess = 'Feedback success';

    // Error message
    // General
    Const.msgError = 'Error';

    // Authenticate
    Const.msgAuthenticateTokenFail = 'Failed to authenticate token';
    Const.msgNoTokenProvide = 'No token provided';
    Const.msgNotValidToken = 'Not valid token';

    // Web API && socket
    // Booking
    Const.msgBookingFail = 'Booking failed';
    Const.msgBookingSuccess = 'Booking success';
    Const.msgDriverNotFound = 'Driver not found';

    // Cancel Trip
    Const.msgCancelSuccess = 'Cancel success';
    Const.msgCancelError = 'Cancel error';
    Const.msgTripNotExist = 'Trip Not Exist';
    Const.msgCustomerCancel = 'Customer cancel trip';
    Const.msgDriverCancel = 'Driver cancel trip';

    // Finish Trip

    // Forget Password Customer

    // Forget Password Driver
    Const.msgCheckEmail = 'New password send. Please check your email';

    // Get Customer Location

    // Get Driver Location
    Const.msgListDriver = 'List Driver';

    // History Customer
    Const.msgListHistory = 'Your all history';
    Const.msgNoHistory = 'You have no history';
    Const.msgHistoryDetail = 'History Detail';

    // Login
    Const.msgLoginSuccess = 'Login success';
    Const.msgSocialIdIncorrect = 'Social Id not found';
    Const.msgPhoneNumberIncorrect = 'Phone number not found';
    Const.msgLoggedIn = 'This account logged in somewhere';
    Const.msgNotActive = 'Account not activate';
    Const.msgPasswordIncorrect = 'Your password incorrect';
    Const.msgBlocked = 'Your account currently block';

    // check promotion
    Const.msgPromotionCodeSuccess = 'Promotion code success';
    Const.msgPromotionCodeIncorrect = 'Incorrect promotion code';
    Const.resPromotionCodeIncorrect = 128;

    // Logout
    Const.msgLogoutSuccess = 'Logout success';

    // Register
    Const.msgRegisterSuccess = 'Register Success';
    Const.msgRegisterFail = 'Register Fail';
    Const.msgDuplicatePhoneNumber = 'This phone number already used';
    Const.msgDuplicateEmail = 'This email already used';

    Const.msgVerifySuccess = 'Verify Success';
    Const.msgVerifyNumberIncorrect = 'Verify Number Incorrect';
    Const.msgNotMatchPhoneNumber = 'Your phone number incorrect with verify code';
    Const.msgNotVerify = 'Your account not verified';

    Const.msgResendSuccess = 'Resend success';

    // Reset Password
    Const.msgResetSuccess = ' Reset success';

    // Config
    Const.msgConfig = 'All config info';
    Const.msgConfigError = 'Error while getting config';
    Const.msgConfigIncorrectId = 'Incorrect Id';

    // Journey Handle
    Const.msgNoBooking = 'No booking';
    Const.msgStartJourneySuccess = 'Start journey success';

    // Rating
    Const.msgRatingSuccess = 'Rating success';

    // socket token
    Const.msgTokenSuccess = "Token success";
    Const.msgNotValidToken = "Not valid token";

    // Exports ----------------------------------------------
    module["exports"] = Const;

})((this || 0).self || global);
