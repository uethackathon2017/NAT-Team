//
//  AppViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupController

class AppViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - Declare
    var typeViewController: TypeViewController = .none {
        didSet {
            switch typeViewController {
            case .root:
                break
            case .child:
                leftButtonType = .back
                // TODO: - ...
                break
            default:
                break
            }
        }
    }
    var leftButtonType: TypeNavigationButton = .none
    var rightButtonType: TypeNavigationButton = .none
    var typeNavigationBar: TypeNavigationBar = .normal
    
    // MARK: - Define
    enum TypeViewController {
        case root
        case child
        case present
        case none
    }
    
    enum TypeNavigationButton {
        case none
        case menu
        case back
        case cancel
        case notification
        case call
        case user(String)
        case stringButton(String)
    }
    
    enum TypeNavigationBar {
        case normal
        case hidden
        case transparent
    }
    
    // MARK: - Setup
    func setupViewController() {
        // Override it
    }
    
    func setupUI() {
        setNavigationBar()
    }
    
    func setupAction() {
        // Override it!!!
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = AppDefine.AppColor.pink
        switch self.typeNavigationBar {
        case .hidden:
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            break
        case .normal:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
            break
        case .transparent:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewController()
        self.setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.setLeftNaviItem()
        self.setRightNaviItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AppViewController {
    func setLeftNaviItem() {
        switch self.leftButtonType {
        case .menu:
            let leftButton = UIBarButtonItem.init(image: UIImage(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftNaviButtonTapped))
            navigationItem.leftBarButtonItem = leftButton
            break
        case .back:
            let leftButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftNaviButtonTapped))
            navigationItem.leftBarButtonItem = leftButton
            break
        case .cancel:
            let leftButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftNaviButtonTapped))
            navigationItem.leftBarButtonItem = leftButton
            break
        case .user(let strAvatar):
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            button.setImage(UIImage.init(named: strAvatar) ?? #imageLiteral(resourceName: "navi_user"), for: .normal)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            let barButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(leftNaviButtonTapped))
            barButton.customView = button
            button.addTarget(self, action: #selector(leftNaviButtonTapped), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = barButton
        case .stringButton(let titleButton):
            let leftButton = UIBarButtonItem.init(title: titleButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftNaviButtonTapped))
            navigationItem.leftBarButtonItem = leftButton
            break
        default:
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func setRightNaviItem() {
        switch self.rightButtonType {
        case .cancel:
            let rightButton = UIBarButtonItem.init(image: UIImage(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightNaviButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
            break
        case .notification:
            let rightButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_noti"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightNaviButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
            break
        case .call:
            let rightButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_call"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightNaviButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
            break
        case .stringButton(let titleButton):
            let rightButton = UIBarButtonItem.init(title: titleButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightNaviButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
            break
        default:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func leftNaviButtonTapped() {
        self.view.endEditing(true)
        switch leftButtonType {
        case .menu:
            fatalError("You need overide this method.")
            break
        case .back:
            if typeViewController == .child {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                fatalError("You need overide this method.")
            }
            break
        case .cancel:
            if typeViewController == .present {
                self.dismiss(animated: true, completion: nil)
            } else {
                fatalError("You need overide this method.")
            }
        case .stringButton(_):
            fatalError("You need overide this method.")
            break
        case .user(let imageName):
            if UIImage.init(named: imageName) != nil{
                fatalError("You need overide this method.")
            }else{
                if let user = storyboard?.instantiateViewController(withIdentifier: "UserViewController" ) as? UserViewController{
                    let navi = UINavigationController(rootViewController: user)
                    self.present(navi, animated: true, completion: nil)
                }
            }
            
            break
        default:
            fatalError("You need overide this method.")
        }
    }
    
    func rightNaviButtonTapped() {
        self.view.endEditing(true)
        switch rightButtonType {
        case .cancel:
            if typeViewController == .present {
                self.dismiss(animated: true, completion: nil)
            } else {
                fatalError("You need overide this method.")
            }
            break
        case .notification:
            if let noti = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController{
                let navi = UINavigationController(rootViewController: noti)
                self.present(navi, animated: true, completion: nil)
            }
            break
        case .call:
            //
            break
        default:
            fatalError("You need overide this method.")
        }
    }
    
}

extension AppViewController {
    func showCall(request: CallRequestResponse, callState: OutCallViewController.CallState) {
        let callVC = OutCallViewController()
        callVC.callState = callState
        callVC.popup = PopupController.create(self.tabBarController ?? self.navigationController ?? self).customize([
            PopupCustomOption.animation(PopupController.PopupAnimation.fadeIn),
            PopupCustomOption.backgroundStyle(PopupController.PopupBackgroundStyle.blackFilter(alpha: 0)),
            PopupCustomOption.dismissWhenTaps(false),
            PopupCustomOption.movesAlongWithKeyboard(true),
            PopupCustomOption.layout(PopupController.PopupLayout.center),
            ]).show(callVC)
        _ = callVC.popup.didCloseHandler { [weak self] (_) in
            if callVC.isAccept {
                let videoVC = VideoCallViewController(nibName: "VideoCallViewController", bundle: nil)
                self?.navigationController?.present(videoVC, animated: true, completion: nil)
            }
        }
    }
    
    func listenCallRequest() {
        VideoCallManager.share.startReceiveCall { [weak self] in
            self?.showCall(request: VideoCallManager.share.callRequest, callState: OutCallViewController.CallState.requestIncommingVideo)
        }
    }
}
