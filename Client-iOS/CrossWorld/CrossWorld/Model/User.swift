//
//  User.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import EVReflection

class User: EVObject {
    
    static var current = User()
    
    var avatar: String?
    var phoneNumber: String?
    var email: String?
    var password: String?
    var userName: String?
    var fullName: String?
    var countryId: String?
    var facebookId: String?
    var languageId: NSNumber?
    var birthday: String?
    
    var user_id: String?
    var token: String?
}
