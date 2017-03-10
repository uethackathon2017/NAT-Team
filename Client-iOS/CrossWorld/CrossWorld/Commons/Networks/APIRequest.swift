//
//  APIRequest.swift
//  socket
//
//  Created by My Macbook Pro on 1/20/17.
//  Copyright © 2017 My Macbook Pro. All rights reserved.
//

import Foundation
import Alamofire

class APIRequest {
//
//    //API Register
//    func RegisterAPI(phone: String, pass: String, name: String, email: String?, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        var params = [
//            "full_name": name,
//            "phone_number": phone,
//            "password": pass
//        ]
//        if let mail = email{
//            if !mail.isBlank {
//                params["email"] = mail
//            }
//        }
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_REGISTER, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API verity acount
//    func verifyPhone(phone: String, code: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "verify_code": code,
//            "phone_number": phone,
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_VETIFY, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API resend verify code
//    func resendVerifyCode(phone: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "phone_number": phone
//            ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_RESENT_VETIFY, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
    //API login
    func loginFacebook(facebook_token: String?, phone_number: String?, password: String? , handle: @escaping (_ isSuscess: Bool, _ user: User?)->Void, handleNotActive: @escaping ()->Void){
        
        var params = Parameters()
        if let facebook_token = facebook_token {
            params["facebook_token"] = facebook_token
        }else{
            params["phone_number"] = phone_number!
            params["password"] = password!
        }
        
        APIHandles().RegisterAPIHandle(urlString: Domain.URL_LOGIN, params: params, method: .post, handle: { (isSuccess, data) in
            if !isSuccess {
                handle(false, nil)
            }else{
                if let data = data {
                    let user = User(dictionary: data)
                    handle(true, user)
                }else{
                    handle(false, nil)
                }
            }

        }) { (res) in
            if res.error_code == "122" {
                handleNotActive()
            }else{
                if res.success {
                    return
                }
                if let err = res.error_code{
                    AlertView.alert(title: err, message: res.message, style: .alert).willCancel().show()
                }
            }
        }
    }

//    //API Forget Password
//    func forgetPassword(phone: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "phone_number": phone
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_FORGET_PASSWORD, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Verify code when forget password
//    func forgetPassVerity(phone: String, verify_code: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "verify_code": verify_code,
//            "phone_number": phone
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_FORGET_PASSWORD_VERIFY, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Change password forget password
//    func forgetPassChangePass(phone: String, new_password: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "new_password": new_password,
//            "phone_number": phone
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_FORGET_PASSWORD_CHANGE_PASS, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Update Account
//    func updateAccount(customer_id: String,home: String, work: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": customer_id,
//            "home": home,
//            "work": work
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_UPDATE_ACCOUNT, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//
//    //API Logout
//    func logout(handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0"
//        ]
//        
//        SocketRequest.share.appSocket.disconnect()
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_LOGOUT, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Cancel Trip
//    func cancelTrip(booking_id: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0",
//            "booking_id": booking_id
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_CANCLE_TRIP, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API History
//    func history(handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0"
//        ]
//        
//        let header : HTTPHeaders = [
//            "x-access-token": User.share.token ?? ""
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_HISTORY, params: params, method: .post, header: header, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API History detail
//    func getHistoryDetail(booking_id: String, handle: @escaping (_ isSuscess: Bool, _ data: HistoryDetail?)->Void){
//        
//        let params = [
//            "booking_id": booking_id
//        ]
//        
//        let header : HTTPHeaders = [
//            "x-access-token": User.share.token ?? ""
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_HISTORY, params: params, method: .post, header: header, handle: { (isSuccess, data) in
//            if isSuccess {
//                let detail = HistoryDetail(dictionary: data!)
//                handle(true, detail)
//            }
//            handle(false, nil)
//        })
//    }
//
//    
//    //API check coupon code
//    func checkCouponCode(promotion_code: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0",
//            "promotion_code": promotion_code
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_CHECK_COUPON_CODE, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Payments
//    func payments(customer_id: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": customer_id
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_PAYMENT, params: params, method: .post, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//
//    //API Reset Password - change pass
//    func resetPassword(password: String, password2: String, handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0",
//            "password": password,
//            "new_password": password2
//        ]
//        
//        let header : HTTPHeaders = [
//                "x-access-token": User.share.token ?? ""
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_RESET_PASSWORD, params: params, method: .post, header: header, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//        })
//    }
//    
//    //API Config
//    func config(handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
//        
//        let params = [
//            "customer_id": User.share.customer_id ?? "0"
//        ]
//        
//        let header : HTTPHeaders = [
//            "x-access-token": User.share.token ?? ""
//        ]
//        
//        APIHandles().RegisterAPIHandle(urlString: Domain.URL_CONFIG, params: params, method: .post,  header: header, handle: { (isSuccess, data) in
//            handle(isSuccess, data)
//            if let data = data {
//                 Config.share = Config(dictionary: data)
//            }
//        })
//    }
//
}
