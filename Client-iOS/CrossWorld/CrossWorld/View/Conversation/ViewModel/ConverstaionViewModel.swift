//
//  ConverstaionViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class ConverstaionViewModel{
    var room: Room?
    
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
