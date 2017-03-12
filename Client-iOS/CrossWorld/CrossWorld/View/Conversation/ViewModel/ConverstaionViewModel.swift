//
//  ConverstaionViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import SwiftDate

class ConverstaionViewModel{
    var room: Room? {
        didSet{
            if let room = room {
                
                room.friend_room = room.foreign_room + room.native_room
                room.friend_room.sort(by: { (item1, item2) -> Bool in
                    if let date1 = item1.time?.getDate(), let date2 = item2.time?.getDate() {
                        return date1 > date2
                    }
                    return false
                })
            }
        }
    }
    
    func reloadData(){
        SocketRequest.share.sendGetAllRoom {
            
        }
    }
    
    func getData(complite: @escaping (_ isComplite: Bool)->Void){
        
        SocketRequest.share.onGetAllRoom { (isSuccess, data) in
            if isSuccess{
                let res = ResObject(dictionary: data)
                if let data = res.data{
                    let room = Room(dictionary: data)
                    self.room = room
                    complite(true)
                }
            }else{
                complite(false)
            }
        }
    }
}
