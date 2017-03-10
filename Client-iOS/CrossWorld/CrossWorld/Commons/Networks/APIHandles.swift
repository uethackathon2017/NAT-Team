//
//  APIHandles.swift
//  socket
//
//  Created by My Macbook Pro on 11/18/16.
//  Copyright © 2016 My Macbook Pro. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
import UIKit



class Response: EVObject {
    var data: String?
}

class ResObject: EVObject {
    
    var data: NSDictionary?
    var success = false
    var error_code: String?
    var message: String = ""
    
    static func handleDataResponse(data: NSDictionary?, handle: (_ isSuccess: Bool, _ data: NSDictionary?)->Void, handleError: ((_ res: ResObject)->Void)? = nil){ //only return handle when success
        
        guard data != nil else {
            AlertView.alert(title: "Fail", message: "Data is nill", style: .alert).willCancel().show()
            handle(false, nil)
            return
        }
        print(data as Any)
        
        let resObject = ResObject(dictionary: data!)
        
        if resObject.success{
            if resObject.data == nil {
                AlertView.alert(title: "Success", message: resObject.message, style: .alert).willCancel().show()
            }
            handle(true, resObject.data)
            
        }else{
            
            if let handleError = handleError{
                handleError(resObject)
            }else{
                AlertView.alert(title: resObject.error_code, message: resObject.message, style: .alert).willCancel().show()
                handle(false, nil)
            }
        }
    }
}

class APIHandles {
    
    //Call in every API
    
    func BaseHanddleWithoutEncripto(urlString: String,method: HTTPMethod, params: Parameters, header: HTTPHeaders? = nil, handle: @escaping (_ suscees: Bool, _ data: NSDictionary?)->(), handleErrorCode: ((_ data: ResObject)->())? = nil){
        if !isInternetAvailable() {
            openWifiSetting()
        }else{
            Alamofire.request(urlString, method: method, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                if response.result.isSuccess{
                    print("Success________________________________")
                    print(response.result.value as Any)
                    if let json =  response.result.value as? NSDictionary {
                        let res = ResObject(dictionary: json)
                        if handleErrorCode != nil {
                            handleErrorCode!(res)
                        }else{
                            if !res.success {
                                if let err = res.error_code{
                                    AlertView.alert(title: err, message: res.message, style: .alert).willCancel().show()
                                }
                            }
                        }
                        
                        handle(res.success, res.data)
                    }else{
                        handle(false, nil)
                    }
                }else{
                    print(response)
                    handle(false, nil)
                    if let error = response.result.error {
                        if AppDefine.AppInfo.developMode {
                            AlertView.alert(title: error.localizedDescription, message: "\(urlString) -- \(params)", style: UIAlertControllerStyle.alert).willCancel().show()
                        }else{
                            AlertView.alert(title: "Error", message: error.localizedDescription, style: UIAlertControllerStyle.alert).willCancel().show()
                        }
                    }else{
                        if AppDefine.AppInfo.developMode {
                            AlertView.alert(title: urlString, message: "\(params)", style: UIAlertControllerStyle.alert).willCancel().show()
                        }else{
                            AlertView.alert(title: "Error", message: "Can't not connect to sever", style: UIAlertControllerStyle.alert).willCancel().show()
                        }
                    }
                }
            }
        }
    }
    
    
    func RegisterAPIHandle(urlString: String, params: Parameters,method: HTTPMethod, header: HTTPHeaders? = nil, handle: @escaping (_ suscees: Bool, _ data: NSDictionary?)->(), handleErrorCode: ((_ data: ResObject)->())? = nil){
        
        if handleErrorCode == nil {
            BaseHanddleWithoutEncripto(urlString: urlString, method: method, params: params, header: header, handle: { (bool, diction) in
            handle(bool, diction)
           })
            
        }else{
            BaseHanddleWithoutEncripto(urlString: urlString, method: method, params: params, header: header, handle: { (bool, diction) in
                handle(bool, diction)
            }) { (res) in
                if handleErrorCode != nil{
                    handleErrorCode!(res)
                }
            }
        }
    }
    
}

