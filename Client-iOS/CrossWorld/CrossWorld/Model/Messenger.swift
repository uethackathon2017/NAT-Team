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
    
    var avatar: String?
    var full_name: String?
    
    var wasRead = false
    var wasSend = false
    var wasSendFail = false
    var wasWritebyMe = true
    
    var photo: UIImage?
    
    var room_id: NSNumber?
    
    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [("content", "message")]
    }
    
    func getCallStatus()->String?{
        switch call_status!.intValue {
        case 0:
            return nil
        case 1:
            return "Đã gọi"
        case 2:
            return "Cuộc gọi nhỡ"
        case 3:
            return "Cuộc gọi bị từ chối"
        default:
            return ""
        }
    }
}

class HistoryMessage: EVObject{
    var history : [Messenger]?
}

extension String{
    func getHourAndMinute() -> String?{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formater.date(from: self){
            return date.stringFormDate()
        }
        
        return nil
    }
    
    func getDate() -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formater.date(from: self){
            return date
        }
        
        return nil
    }
}

extension Date{
    func stringFormDate() -> String{
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: self)
    }
    
    func string() -> String{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.timeZone = TimeZone(abbreviation: "UTC")
        
        return formater.string(from: self)
    }
}
