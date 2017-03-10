//
//  Message.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class Messenger {
    
    var id: String?
    var content: String?
    var timeStamp: Double?
    var wasRead = false
    var wasWritebyMe = true
    
    init(){
        
    }
    
    init(content: String, fromMe: Bool = true){
        self.wasRead = false
        self.wasWritebyMe = true
        self.content = content
    }
    
    func fakeListMessage() -> [Messenger]{
        var list = [Messenger]()
        for item in 1...16 {
            let mes = Messenger(content: "\(item) unexpectedly found nil while unwrapping an Optional value \(item)")
            
            if item % 2 == 0 {
                mes.wasWritebyMe = false
            }
            list.append(mes)
        }
        return list
    }
}
