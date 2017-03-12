//
//  Utils.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import SystemConfiguration
import AVFoundation

class Utils {
    
    // MARK: - ViewController
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.topViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let child = base?.childViewControllers.last {
            return topViewController(child)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    // MARK: - Alert
    
    class func showAlertDefault(_ title: String?, message: String?, buttons: [String], completed:((_ index: Int) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if buttons.count == 1 {
            alert.addAction(UIAlertAction(title: buttons[0], style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                completed?(0)
            }))
        } else if buttons.count > 1 {
            for (index, title) in buttons.enumerated() {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    completed?(index)
                }))
            }
        }
        Utils.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func showActions(with title: String?, buttons: [String], completionHandle: ((_ index: Int) -> Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for (index, title) in buttons.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (action) in
                completionHandle?(index)
                print("index: \(index)")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        Utils.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Internet
    class func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

// MARK: - Network
extension Utils {
    
    static var networkLength: Float = 0
    
    class func getStrength() {
        let url = URL(string: "http://google.com")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        _ = Date()
        
        let task =  session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                
                print("connection error or data is nill")
                
                return
            }
            
            guard resp != nil else{
                
                print("respons is nill")
                return
            }
            
            
            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            Utils.networkLength = Float(length)
            
            //            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
        }
        task.resume()
    }
}

extension Utils {
    
    // Phone
    class func makePhoneCall(to phoneNumber: String) {
        guard let number = URL(string: "telprompt://" + phoneNumber) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: "tel://" + phoneNumber)!)
        }
    }
    
    class func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    }
    
}
