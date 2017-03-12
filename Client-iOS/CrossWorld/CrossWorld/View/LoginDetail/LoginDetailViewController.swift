//
//  LoginDetailViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import Bond

class LoginDetailViewController: AppViewController {

    // MARK: - Outlet
    @IBOutlet weak var txtMobile: ASTextField!
    @IBOutlet weak var txtPass: ASTextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Declare
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AppViewController
    override func setupViewController() {
        self.typeViewController = .child
        self.typeNavigationBar = .transparent
        self.rightButtonType = .none
        self.leftButtonType = .back
    }
    
    override func setupAction() {
        self.btnLogin.addTarget(nil, action: #selector(login), for: .touchUpInside)
    }
    
    // MARK: - Action
    func validLogin() -> AppError {
        let res = AppError()
        if (txtMobile.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankMobile
            return res
        }
        
        if (txtPass.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankPass
            return res
        }
        
        return res
    }
    
    func login() {
        let valid = self.validLogin()
        if valid.isError {
            BannerManager.share.showMessage(withContent: valid.errorType.rawValue, theme: BannerManager.BannerTheme.error)
        } else {
            APIRequest.share.loginFacebook(facebook_token: nil, phone_number: txtMobile.text!, password: txtPass.text!, handle: { [weak self] (isSuccess, user) in
                if isSuccess {
                    AppAccess.shared.saveUser(user)
                    User.current = user ?? User()
                    self?.performSegue(withIdentifier: AppDefine.Segue.loginDetailToHome, sender: nil)
                }
            }, handleNotActive: { 
                //
            })
        }
    }
    
}
