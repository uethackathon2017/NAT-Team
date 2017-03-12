//
//  FriendViewModel.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class FriendViewModel {
    
    var listAction: [String] = [
        "Yêu cầu kết bạn",
        "Tìm kiếm bạn bè",
        "Mời bạn bè"
    ]
    
    struct PeopleCellDescription {
        var title: String = ""
        var urlAvatar: String = ""
    }
    
    var listPeople: [PeopleCellDescription] = [
        PeopleCellDescription(title: "Phạm Vân Anh‎", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Bé Bủn", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Trinh Phạm", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Clever Tran", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Tran Anh Diep", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Vân Ớt", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Nhượng Duy Đỗ", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Hằng Híp", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Anh Son", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Hoàngg Thanhh Hươngg", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Anh Đức Lê", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Lương Trần Đài Nguyên", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Anh Bin", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Anh Son", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Nhượng Duy Đỗ", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png"),
        PeopleCellDescription(title: "Hằng Híp", urlAvatar: "http://68.media.tumblr.com/avatar_706b2f805cc1_128.png")
    ]
    
    struct SpotyCellDescription {
        var title: String = ""
        var users: [User] = []
    }
    
    var listSpotyCell: [SpotyCellDescription] = [
        
    ]
    
    func getListRandom(completeHandle:(([User])->())?) {
        let param = [
            "user_id": User.current.user_id ?? ""
        ]
        SocketRequest.share.appSocket.emit("get-random-room", param)
        SocketRequest.share.appSocket.on("get-random-room") { (data, ack) in
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data {
                    if let dataRandom = data.value(forKey: "random") as? [NSDictionary] {
                        let listRandom = [User].init(dictionaryArray: dataRandom)
                        completeHandle?(listRandom)
                        SocketRequest.share.appSocket.off("get-random-room")
                    } else {
                        completeHandle?([])
                    }
                }else{
                    completeHandle?([])
                }
            }
        }
    }
    
}
