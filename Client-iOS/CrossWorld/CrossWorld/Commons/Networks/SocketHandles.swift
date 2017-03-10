////
////  ManagerTranferDataSocket.swift
////  socket
////
////  Created by My Macbook Pro on 10/28/16.
////  Copyright © 2016 My Macbook Pro. All rights reserved.
////
//
//import Foundation
//
//func emit(event: String, data: [AnyObject]){
//    emit(message: event , data: data) { data in
//        if data.0 == nil {
//            print("emit success")
//            return
//        }else{
//            if let event = data.0, let data = data.1{
//                ResentObject.shareIntances.append(ResentObject(event: event, data: data))
//            }
//        }
//    }
//}
//
//func emit(message: String, data: [AnyObject], callback: @escaping(_ event: String?, _ data: [AnyObject]?) -> ()) {
//  //  if isConected { //TODO- handle case disconect
////        let ack = socket.emitWithAck(message, data)
////        ack.timingOut(after: 3, callback: { response in
////            if let str = response.first as? String {
////                if str == "NO ACK" {
////                    NSLog("No ack from server")
////                    callback(message,[data as AnyObject])
////                } else {
////                    callback(nil, nil)
////                }
////            } else {
////                print("Unexpected response from server: \(response)")
////                callback(message,[data as AnyObject])
////            }
////        })
////    }
//}
