//
//  RegisterViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import Bond

class RegisterViewController: AppViewController {

    // MARK: - Outlet
    
    // Button
    @IBOutlet weak var btnNext: UIButton!
    
    // Form
    @IBOutlet weak var txtName: ASTextField!
    @IBOutlet weak var txtMobile: ASTextField!
    
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
        
        // Button
        _ = self.btnNext.reactive.tap.observeNext { [weak self] in
            self?.btnNextTap()
        }
        
        // Text
        _ = self.txtMobile.reactive.text.observeNext(with: { (text) in
            User.current.phoneNumber = text
        })
        
        _ = self.txtName.reactive.text.observeNext(with: { (text) in
            User.current.userName = text
        })
    }
    
    // MARK: - Action
    func btnNextTap() {
        let valid = self.veriryForm()
        if valid.isError {
            BannerManager.share.showMessage(withContent: valid.errorType.rawValue, theme: .error)
        } else {
            self.performSegue(withIdentifier: AppDefine.Segue.registerToDetail, sender: nil)
        }
    }
    
    func veriryForm() -> AppError {
        
        let res = AppError()
        if let phone = User.current.phoneNumber, !phone.isBlank {
            if !phone.isPhone {
                res.isError = true
                res.errorType = .blankMobile
                return res
            }
        } else {
            res.isError = true
            res.errorType = .blankMobile
            return res
        }
        
        if (User.current.userName ?? "").isBlank {
            res.isError = true
            res.errorType = .blankUserName
            return res
        }
        
        return res
    }

}
