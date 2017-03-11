//
//  OutCallViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import Bond
import PopupController

class OutCallViewController: AppViewController, PopupContentViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnEndCall: UIButton!
    @IBOutlet weak var btnAnswer: UIButton!
    
    // MARK: - Declare
    var popup = PopupController()
    
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
    
    override func setupViewController() {
        self.typeViewController = .present
        self.typeNavigationBar = .hidden
    }
    
    override func setupAction() {
        _ = self.btnEndCall.reactive.tap.observeNext {
            self.popup.dismiss()
        }
    }
    
    // MARK: - Popup
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return AppDefine.Define.sizeOfScreen
    }

}
