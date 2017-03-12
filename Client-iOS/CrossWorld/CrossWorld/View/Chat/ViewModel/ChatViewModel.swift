//
//  ChatViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftMessages

class ChatViewModel{
    
    var listMessenger = [Messenger]()
    
    func sendGetMessage(room_id: String, page: String?, complite: ()->Void){
        var param = [
            "room_id" : room_id
        ]
        if let pageCheck = page{
            param["page"] = pageCheck
        }
        SocketRequest.share.appSocket.emit(SocketEvent.CHAT_ROOM_DETAIL, param)
    }
    
    func reverseListMessage(){
        guard listMessenger.count != 0 else {
            return
        }
        var list = [Messenger]()
        
        for item in listMessenger{
            list.insert(item, at: 0)
        }
        
        listMessenger = list
    }
    
    func onGetMessage(complite: @escaping (_ isComplite: Bool)->Void){
        SocketRequest.share.appSocket.off(SocketEvent.CHAT_ROOM_DETAIL)
        SocketRequest.share.appSocket.on(SocketEvent.CHAT_ROOM_DETAIL) { [weak self] (data, ack) in
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data{
                    let room = HistoryMessage(dictionary: data)
                    if let list = room.history {
                        self!.listMessenger = list
                        self!.reverseListMessage()
                        complite(true)
                    }else{
                        complite(false)
                    }
                }else{
                    complite(false)
                }
            }
        }
    }
    
    func sendNewMessage(room_id: String, meesage: String, complite: @escaping (_ isSuccess: Bool)->Void){
        let param: Parameters = [
            "room_id" : room_id,
            "user_id": User.current.user_id ?? "",
            "message": meesage,
            ]
        
        SocketRequest.share.appSocket.emitWithAck(SocketEvent.SEND_MESSAGE, param).timingOut(after: 5) { (data) in
            if let data = data.first as? Int{
                if data == 1 {
                    complite(true)
                }else{
                    complite(false)
                }
            }else{
                complite(false)
            }
        }
    }
    
    func sendNewPhoto(room_id: String, image: UIImage, complite: @escaping (_ isSuccess: Bool)->Void){
        
        
        var param: Parameters = [
            "room_id" : room_id,
            "user_id": User.current.user_id ?? "",
            ]
        
        let imageBase64 = UIImagePNGRepresentation(image)
        if let encode = imageBase64?.base64EncodedString(options: .lineLength64Characters){
            param["image"] = encode
        }
        
        SocketRequest.share.appSocket.emitWithAck(SocketEvent.SEND_MESSAGE, param).timingOut(after: 15) { (data) in
            if let data = data.first as? NSNumber{
                if data.intValue == 1 {
                    complite(true)
                }else{
                    complite(false)
                }
            }else{
                complite(false)
            }
        }
    }
    
    func onGetNewMessage(complite: @escaping (_ isComplite: Bool)->Void){
        SocketRequest.share.appSocket.off(SocketEvent.SEND_MESSAGE)
        SocketRequest.share.appSocket.on(SocketEvent.SEND_MESSAGE) { [weak self] (data, ack) in
            //Test self push noti
            if let selfStrong = self{
                if let data = data.first as? NSDictionary{
                    let res = ResObject(dictionary: data)
                    if let data = res.data{
                        let room = Messenger(dictionary: data)
                        selfStrong.listMessenger.append(room)
                        complite(true)
                    }else{
                        complite(false)
                    }
                }else{
                    complite(false)
                }
            }
        }
    }
    
}





