//
//  AppAccess.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class AppAccess {
    
    struct Key {
        static var kUser = "kUser"
        static var kUserPass = "kUserPass"
    }
    
    static var shared = AppAccess()
    
    var prefs = UserDefaults.standard
    
    // MARK: - User
    
    func saveUser(_ user: User?) {
        if let clearUser = user {
            let encodeData = NSKeyedArchiver.archivedData(withRootObject: clearUser)
            prefs.set(encodeData, forKey: Key.kUser)
            prefs.synchronize()
        }
    }
    
    func getUser() -> User? {
        let data = prefs.object(forKey: Key.kUser) as? Data
        if data != nil {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? User
        }
        return nil
    }
    
    func removeUser() {
        prefs.removeObject(forKey: Key.kUser)
    }
    
    // MARK: - Pass
    
    func savePass(_ user: User?) {
        if let clearUser = user {
            let encodeData = NSKeyedArchiver.archivedData(withRootObject: clearUser)
            prefs.set(encodeData, forKey: Key.kUserPass)
            prefs.synchronize()
        }
    }
    
    func getPass() -> User? {
        let data = prefs.object(forKey: Key.kUserPass) as? Data
        if data != nil {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? User
        }
        return nil
    }
    
    func removePass() {
        prefs.removeObject(forKey: Key.kUserPass)
    }
    
}


