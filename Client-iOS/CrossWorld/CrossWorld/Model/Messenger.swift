//
//  Message.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import EVReflection

class Messenger : EVObject{
    var call_status: NSNumber?
    var chat_message_id: NSNumber?
    var image: String?
    var sender: String?
    var content: String?
    var time: String?
    
    var wasRead = false
    var wasSend = false
    var wasSendFail = false
    var wasWritebyMe = true
    
    var room_id: NSNumber?
    
    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [("content", "message")]
    }
}

class HistoryMessage: EVObject{
    var history : [Messenger]?
}
