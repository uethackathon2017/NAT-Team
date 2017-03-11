//
//  DataAccess.swift
//  LifePlus-iOS-Master
//
//  Created by Anh Son Le on 1/20/17.
//  Copyright © 2017 Kane. All rights reserved.
//

import Foundation

class DataAccess {
    struct Key {
        static var kUser = "kUser"
    }
    
    static var shared = DataAccess()
    
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
}
