//
//  ChatViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

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
    
    //        SocketRequest.share.onGetRoomDetail { [weak self] (isSuccess, data) in
    //            guard self != nil else {
    //                complite(false)
    //                return
    //            }
    //

}
