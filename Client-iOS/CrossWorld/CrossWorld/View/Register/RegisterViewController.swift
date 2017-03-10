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
        _ = self.btnNext.reactive.tap.observeNext { [weak self] in
            self?.btnNextTap()
        }
    }
    
    // MARK: - Action
    func btnNextTap() {
        self.performSegue(withIdentifier: AppDefine.Segue.registerToDetail, sender: nil)
    }

}
