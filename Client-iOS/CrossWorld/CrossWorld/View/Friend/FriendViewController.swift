//
//  FriendViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class FriendViewController: AppViewController {

    // MARK: - Outlet
    
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
        self.typeViewController = .root
        self.typeNavigationBar = .normal
        self.rightButtonType = .notification
        self.leftButtonType = .user("")
        self.title = "CrossWorld"
    }

}
