//
//  BannerManager.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import SwiftMessages

/*
 Use class to manager banner.
 Use with SwiftMessages 3.1.3
 **/
class BannerManager {
    
    var defaultColor = UIColor.init(red: 245, green: 166, blue: 35, alpha: 1)
    var errorColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 1)
    var successColor = UIColor.init(red: 126, green: 211, blue: 33, alpha: 1)
    var warningColor = UIColor.init(red: 248, green: 231, blue: 28, alpha: 1)
    
    enum BannerTheme {
        case defaultTheme
        case error
        case success
        case warning
        case custom(String, String)
    }
    
    let idMessage = "idMessage"
    let idStatusLine = "idStatusLine"
    let idWaiting = "idWaiting"
    
    static let share = BannerManager()
    
    var themeMessage: BannerTheme = .defaultTheme {
        didSet {
            switch themeMessage {
            case .defaultTheme:
                viewMessage.configureTheme(backgroundColor: UIColor.orange, foregroundColor: UIColor.white)
                break
            case .error:
                viewMessage.configureTheme(Theme.error)
                break
            case .success:
                viewMessage.configureTheme(Theme.success)
                break
            case .warning:
                viewMessage.configureTheme(Theme.warning)
                break
            case .custom(let hexBackgrondColor, let hexMessageColor):
                viewMessage.configureTheme(backgroundColor: UIColor.initFromHex(hexString: hexBackgrondColor), foregroundColor: UIColor.initFromHex(hexString: hexMessageColor))
                break
            }
        }
    }
    
    var themeStatusBanner: BannerTheme = .defaultTheme {
        didSet {
            switch themeStatusBanner {
            case .defaultTheme:
                viewStatusBaner.configureTheme(backgroundColor: UIColor.orange, foregroundColor: UIColor.white)
                break
            case .error:
                viewStatusBaner.configureTheme(Theme.error)
                break
            case .success:
                viewStatusBaner.configureTheme(Theme.success)
                break
            case .warning:
                viewStatusBaner.configureTheme(Theme.warning)
                break
            case .custom(let hexBackgrondColor, let hexMessageColor):
                viewStatusBaner.configureTheme(backgroundColor: UIColor.initFromHex(hexString: hexBackgrondColor), foregroundColor: UIColor.initFromHex(hexString: hexMessageColor))
                break
            }
        }
    }
    
    // MARK: - SwiftMessages
    var viewMessage = MessageView.viewFromNib(layout: MessageView.Layout.MessageView)
    var viewStatusBaner = MessageView.viewFromNib(layout: MessageView.Layout.StatusLine)
    var viewWaiting = MessageView.viewFromNib(layout: MessageView.Layout.StatusLine)
    var configMessage = SwiftMessages.Config()
    var configStatusLine = SwiftMessages.Config()
    var configWaiting = SwiftMessages.Config()
    
    // MARK: - Method
    private func configMesage() {
        SwiftMessages.pauseBetweenMessages = 0.1
        viewMessage.id = idMessage
        viewMessage.button?.isHidden = true
        viewMessage.iconImageView?.isHidden = true
        viewMessage.titleLabel?.isHidden = true
        viewMessage.bodyLabel?.textAlignment = .center
        viewMessage.bodyLabel?.font = UIFont.systemFont(ofSize: 16)
        configMessage.dimMode = .none
        configMessage.ignoreDuplicates = false
        configMessage.interactiveHide = true
        configMessage.shouldAutorotate = false
    }
    
    private func configStatusBanner() {
        SwiftMessages.pauseBetweenMessages = 0.1
        viewStatusBaner.id = idStatusLine
        viewStatusBaner.button?.isHidden = true
        viewStatusBaner.iconImageView?.isHidden = true
        viewStatusBaner.titleLabel?.isHidden = true
        viewStatusBaner.bodyLabel?.textAlignment = .center
        viewStatusBaner.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        viewStatusBaner.alpha = 1
        configStatusLine.eventListeners.removeAll()
        configStatusLine.dimMode = .none
        configStatusLine.ignoreDuplicates = false
        configStatusLine.interactiveHide = true
        configStatusLine.shouldAutorotate = false
    }
    
    private func configWaitingView(_ isStatus: Bool, inViewController: UIViewController?) {
        SwiftMessages.pauseBetweenMessages = 0.1
        viewWaiting.id = idWaiting
        viewWaiting.button?.isHidden = true
        viewWaiting.iconImageView?.isHidden = true
        viewWaiting.titleLabel?.isHidden = true
        viewWaiting.bodyLabel?.textAlignment = .center
        viewWaiting.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        viewWaiting.alpha = 1
        configWaiting.eventListeners.removeAll()
        configWaiting.dimMode = .none
        configWaiting.ignoreDuplicates = false
        configWaiting.interactiveHide = false
        configWaiting.shouldAutorotate = false
        if isStatus {
            configWaiting.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        } else {
            if let topVC = inViewController {
                configWaiting.presentationContext = .viewController(topVC)
            } else {
                configWaiting.presentationContext = .automatic
            }
        }
        
        configWaiting.presentationStyle = .top
    }
    
    func showMessage(withContent content: String, theme: BannerTheme) {
        SwiftMessages.hide()
        configMesage()
        viewMessage.configureContent(body: content)
        self.themeMessage = theme
        configMessage.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        configMessage.presentationStyle = .top
        
        SwiftMessages.show(config: configMessage, view: viewMessage)
    }
    
    func showMessageUnderNavi(withContent content: String, theme: BannerTheme) {
        SwiftMessages.hide()
        configMesage()
        viewMessage.configureContent(body: content)
        self.themeMessage = theme
        if let topVC = Utils.topViewController() {
            configWaiting.presentationContext = .viewController(topVC)
        } else {
            configWaiting.presentationContext = .automatic
        }
        configMessage.presentationStyle = .top
        
        SwiftMessages.show(config: configMessage, view: viewMessage)
    }
    
    func showStatusMessage(withContent content: String, theme: BannerTheme, inViewController: UIViewController?) {
        SwiftMessages.hide()
        configStatusBanner()
        configStatusLine.duration = .seconds(seconds: 2)
        self.themeStatusBanner = theme
        viewStatusBaner.configureContent(body: content)
        configStatusLine.presentationStyle = .top
        if let topVC = inViewController {
            configStatusLine.presentationContext = .viewController(topVC)
        } else {
            configStatusLine.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        }
        
        SwiftMessages.show(config: configStatusLine, view: viewStatusBaner)
    }
    
    func showWaiting(withContent content: String, isStatusLevel: Bool, inViewController: UIViewController?) {
        SwiftMessages.hide()
        configWaitingView(isStatusLevel, inViewController: inViewController)
        viewWaiting.configureContent(body: content)
        configWaiting.duration = .forever
        configWaiting.eventListeners.append({ event in
            if case .didShow = event {
                UIView.animate(withDuration: 0.5, delay: 0, options: [UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.repeat], animations: {
                    self.viewWaiting.alpha = 0.88
                }, completion: nil)
            }
        })
        viewWaiting.configureTheme(backgroundColor: UIColor.orange, foregroundColor: UIColor.white)
        SwiftMessages.show(config: configWaiting, view: viewWaiting)
    }
    
    func hideWaiting() {
        SwiftMessages.hide(id: idWaiting)
        configWaiting.eventListeners.removeAll()
    }
    
}

/// Colors was used in Banner
extension UIColor {
    internal struct bannerColor {
        static var defaultColor = UIColor.init(red: 245, green: 166, blue: 35, alpha: 1)
        static var error = UIColor.init(red: 255, green: 0, blue: 0, alpha: 1)
        static var success = UIColor.init(red: 126, green: 211, blue: 33, alpha: 1)
        static var warning = UIColor.init(red: 248, green: 231, blue: 28, alpha: 1)
    }
    
    static func initFromHex(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        func intFromHexString(hexStr: String) -> UInt32 {
            var hexInt: UInt32 = 0
            // Create scanner
            let scanner: Scanner = Scanner(string: hexStr)
            // Tell scanner to skip the # character
            scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
            // Scan hex value
            scanner.scanHexInt32(&hexInt)
            return hexInt
        }
        // Convert hex string to an integer
        let hexint = Int(intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

