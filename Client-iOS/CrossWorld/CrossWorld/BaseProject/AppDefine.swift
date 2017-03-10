//
//  AppDefine.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class AppDefine {
    // MARK: - App Info
    struct AppInfo {
        static var developMode = true
    }
    
    struct AppColor {
        static var pink = UIColor.init(red: 360/255, green: 62/255, blue: 100/255, alpha: 100)
    }
    
    // MARK: - Screen ID / Class File Name
    struct Screen {
        
    }
    
    // MARK: - Segue ID
    struct Segue {
        // Login/Register
        static var registerToDetail = "registerToDetail"
    }
    
    // MARK: - Define
    struct Define {
        static let sizeOfScreen = UIScreen.main.bounds.size
    }
    
    // MARK: - cell/item ID
    struct cellId {
        
    }
    
}
