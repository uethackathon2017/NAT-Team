//
//  HomeViewModel.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class HomeViewModel {
    struct CellDescription {
        var title: String = ""
        var image: String = ""
    }
    
    var listCell: [CellDescription] = [
        CellDescription(title: "Xếp hạng cộng tác viên", image: "home_body"),
        CellDescription(title: "Lịch sử", image: "home_record"),
        CellDescription(title: "Chat với người bản xứ", image: "home_chat"),
        CellDescription(title: "Kết quả học tập", image: "home_resource")
    ]
    
    func newClient(){
        SocketRequest.share.login()
    }
}
