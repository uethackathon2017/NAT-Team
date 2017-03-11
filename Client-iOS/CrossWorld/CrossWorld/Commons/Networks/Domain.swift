//
//  Domain.swift
//  socket
//
//  Created by My Macbook Pro on 2/7/17.
//  Copyright © 2017 My Macbook Pro. All rights reserved.
//

import Foundation

class Domain{
    static let IP = "http://172.20.10.7:3000/"
    
    static let DOAMIN_SOCKET = IP
    static let DOAMIN_API = IP + ":8443"
    static let DOMAIN_HTTP_SOCKET = "http://" + DOAMIN_SOCKET
    static let DOMAIN_HTTPS = "https://" + DOAMIN_API
    static let DOMAIN_URL = IP + "api/"
    
    static let URL_LOGIN = DOMAIN_URL + "login"
    
    static let URL_REGISTER = DOMAIN_URL + "/register"
    static let URL_VETIFY = DOMAIN_URL + "/customer/register/verify"
    static let URL_RESENT_VETIFY = DOMAIN_URL + "/customer/register/resend-verify"
    static let URL_FORGET_PASSWORD = DOMAIN_URL + "/customer/forget-password"
    static let URL_FORGET_PASSWORD_VERIFY = DOMAIN_URL + "/customer/forget-password/verify"
    static let URL_FORGET_PASSWORD_CHANGE_PASS = DOMAIN_URL + "/customer/forget-password/change-password"
    static let URL_UPDATE_ACCOUNT = DOMAIN_URL + "/customer/update-account"
    static let URL_LOGOUT = DOMAIN_URL + "/customser/logout"
    static let URL_CANCLE_TRIP = DOMAIN_URL + "/customer/cancel-trip"
    static let URL_HISTORY = DOMAIN_URL + "/customer/history"
    static let URL_HISTORY_DETAIL = DOMAIN_URL + "/customer/history/detail"
    static let URL_PAYMENT = DOMAIN_URL + "/customer/payment"
    static let URL_RESET_PASSWORD = DOMAIN_URL + "/customer/reset-password"
    static let URL_CONFIG = DOMAIN_URL + "/customer/config"
    static let URL_CHECK_COUPON_CODE = DOMAIN_URL + "/customer/check-promotion"
}

//class Domain{
//    static let IP = "54.169.121.38"
//    
//    static let DOAMIN_SOCKET = IP + ":80"
//    static let DOAMIN_API = IP + ":443"
//    static let DOMAIN_HTTP_SOCKET = "http://" + DOAMIN_SOCKET
//    static let DOMAIN_HTTPS = "https://" + DOAMIN_API
//    static let DOMAIN_URL = DOMAIN_HTTPS +  "/api"
//    
//    static let URL_REGISTER = DOMAIN_URL + "/customer/register"
//    static let URL_VETIFY = DOMAIN_URL + "/customer/register/verify"
//    static let URL_RESENT_VETIFY = DOMAIN_URL + "/customer/register/resend-verify"
//    static let URL_LOGIN = DOMAIN_URL + "/customer/login"
//    static let URL_FORGET_PASSWORD = DOMAIN_URL + "/customer/forget-password"
//    static let URL_FORGET_PASSWORD_VERIFY = DOMAIN_URL + "/customer/forget-password/verify"
//    static let URL_FORGET_PASSWORD_CHANGE_PASS = DOMAIN_URL + "/customer/forget-password/change-password"
//    static let URL_UPDATE_ACCOUNT = DOMAIN_URL + "/customer/update-account"
//    static let URL_LOGOUT = DOMAIN_URL + "/customser/logout"
//    static let URL_CANCLE_TRIP = DOMAIN_URL + "/customer/cancel-trip"
//    static let URL_HISTORY = DOMAIN_URL + "/customer/history"
//    static let URL_HISTORY_DETAIL = DOMAIN_URL + "/customer/history/detail"
//    static let URL_PAYMENT = DOMAIN_URL + "/customer/payment"
//    static let URL_RESET_PASSWORD = DOMAIN_URL + "/customer/reset-password"
//    static let URL_CONFIG = DOMAIN_URL + "/customer/config"
//    static let URL_CHECK_COUPON_CODE = DOMAIN_URL + "/customer/check-promotion"
//}
