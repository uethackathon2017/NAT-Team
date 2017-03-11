//
//  UserViewModel.swift
//  socket
//
//  Created by My Macbook Pro on 2/22/17.
//  Copyright © 2017 My Macbook Pro. All rights reserved.
//

import Foundation

class CellUser{
    
    var des: String?
    var title: String?
    var textLeft: String?
    var image: String?
    var isBottomInSession = false
    var isTopInSecction = false
    var height = 0
    
    var segue: String?
    
    init(des: String? = nil, title: String? = nil, textLeft: String? = nil, image: String? = nil, isBottomInSession: Bool = false, isTopInSecction: Bool = false, height: Int = 0, segue: String? = nil) {
        self.des = des
        self.title = title
        self.textLeft = textLeft
        self.image = image
        self.isBottomInSession = isBottomInSession
        self.isTopInSecction = isTopInSecction
        self.height = height
        self.segue = segue
    }
}

//class TDTBCell{
//    var listCells = [CellUser]()
//}

class TDTBSession{
    var headerHeight = 0
    var footerHeihgt = 0
    var cells = [CellUser]()
    
    init(headerHeight: Int = 0, footerHeihgt: Int = 0, cells: [CellUser]) {
        self.headerHeight = headerHeight
        self.footerHeihgt = footerHeihgt
        self.cells = cells
    }
}

class TDTableData {
    var sesstions = [TDTBSession]()
    
    required init(sesstions: [TDTBSession]) {
        self.sesstions = sesstions
    }
}

class UserModel {
    var tbDataSource = [
        TDTBSession.init(headerHeight: 0, footerHeihgt: 0, cells: [
            CellUser.init(des: nil, title: nil, textLeft: nil, image: nil, isBottomInSession: false, isTopInSecction: false, height: 140),
            CellUser.init(des: nil, title: "Name", textLeft: User.current.fullName ?? "Your name", image: nil, isBottomInSession: false, isTopInSecction: false, height: 44),
            CellUser.init(des: nil, title: "Phone", textLeft: User.current.phoneNumber ?? "Your phone", image: nil, isBottomInSession: false, isTopInSecction: false, height: 44),
            CellUser.init(des: nil, title: "Email", textLeft: User.current.email ?? "Your email", image: nil, isBottomInSession: true, isTopInSecction: false, height: 44)
            ]),
        TDTBSession.init(headerHeight: 28, footerHeihgt: 0, cells: [
            CellUser.init(des: "Setting your notification you will recieve", title: "Notification", textLeft: nil, image: nil, isBottomInSession: true, isTopInSecction: true, height: 50)
            ]),
        TDTBSession.init(headerHeight: 28, footerHeihgt: 0, cells: [
            CellUser.init(des: "Manager your saved places", title: "Your place", textLeft: nil, image: nil, isBottomInSession: true, isTopInSecction: true, height: 50)
            ]),
        TDTBSession.init(headerHeight: 28, footerHeihgt: 0, cells: [
            CellUser.init(des: nil, title: "Facebook", textLeft: "Connect Facebook", image: "ic_fb", isBottomInSession: false, isTopInSecction: true, height: 44),
            CellUser.init(des: nil, title: "Google", textLeft: "Connect Google Plus", image: "ic_google", isBottomInSession: true, isTopInSecction: false, height: 44),
            
            ]),
        TDTBSession.init(headerHeight: 28, footerHeihgt: 0, cells: [
            CellUser.init(des: nil, title: "Change password", textLeft: nil, image: nil, isBottomInSession: true, isTopInSecction: true, height: 44)
            ]),
        
        TDTBSession.init(headerHeight: 28, footerHeihgt: 14, cells: [
            CellUser.init(des: nil, title: nil, textLeft: nil, image: nil, isBottomInSession: false, isTopInSecction: false, height: 44)
            ])
        ]
    
    func getCellData(index: IndexPath)->CellUser{
        return tbDataSource[index.section].cells[index.row]
    }
}
