//
//  ChatViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import Alamofire

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
    
    func onGetMessage(complite: @escaping (_ isComplite: Bool)->Void){
        SocketRequest.share.appSocket.off(SocketEvent.CHAT_ROOM_DETAIL)
        SocketRequest.share.appSocket.on(SocketEvent.CHAT_ROOM_DETAIL) { [weak self] (data, ack) in
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data{
                    let room = HistoryMessage(dictionary: data)
                    if let list = room.history {
                        self!.listMessenger = list
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
    
    func onGetNewMessage(complite: @escaping (_ isComplite: Bool)->Void){
        SocketRequest.share.appSocket.off(SocketEvent.SEND_MESSAGE)
        SocketRequest.share.appSocket.on(SocketEvent.SEND_MESSAGE) { [weak self] (data, ack) in
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data{
                    let room = Messenger(dictionary: data)
                    self?.listMessenger.append(room)
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



