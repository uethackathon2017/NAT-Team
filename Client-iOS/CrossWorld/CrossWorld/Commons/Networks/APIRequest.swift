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
    
    ///Instance
    static let share = APIRequest()

    //API Register
    func registerAPI(handle: @escaping (_ isSuscess: Bool, _ data: NSDictionary?)->Void){
        var params: Parameters = [
            "full_name": User.current.fullName ?? "",
            "phone_number": User.current.phoneNumber ?? "",
            "password": User.current.password ?? "",
            "user_name": User.current.userName ?? "",
            "country_id": User.current.countryId ?? "",
            "language_id": User.current.languageId?.intValue ?? "",
            "birthday": User.current.birthday ?? "",
        ]
    
        if let facebookid = User.current.facebookId {
            params["facebook_id"] = facebookid
        }

        APIHandles().RegisterAPIHandle(urlString: Domain.URL_REGISTER, params: params, method: .post, handle: { (isSuccess, data) in
            handle(isSuccess, data)
        })
    }
    
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

}
