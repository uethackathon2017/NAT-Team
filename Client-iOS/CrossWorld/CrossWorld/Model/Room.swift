//
//  Room.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import EVReflection

class RoomDetail: EVObject{
    var avatar: String?
    var call_status: NSNumber?
    var chat_message_id: NSNumber?
    var image: NSData?
    var login_status: NSNumber?
    var message: String?
    var room_id: NSNumber?
    var sender: String?
    var time: String?
    var user_id: String?
    var user_name: String?
    var full_name: String?
}

class Room: EVObject{
    
    var foreign_room: [RoomDetail] = []
    var friend_room: [RoomDetail] = []
    var native_room: [RoomDetail] = []
    
}
