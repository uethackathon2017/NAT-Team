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
    
    @IBOutlet weak var centerBtnAnswerConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerBtnEndConstraint: NSLayoutConstraint!
    
    // MARK: - Declare
    enum CallState {
        case waitingAnswer
        case requestIncommingCall
        case incommingCall
    }
    var popup = PopupController()
    var callState: CallState = .incommingCall {
        didSet {
//            setupUI()
        }
    }
    
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
    
    override func setupUI() {
        switch callState {
        case .requestIncommingCall:
            self.btnAnswer.isHidden = false
            self.btnEndCall.isHidden = false
            self.centerBtnAnswerConstraint.constant = -90
            self.centerBtnEndConstraint.constant = 90
            self.lblTime.text = "Cuộc gọi video"
            break
        case .waitingAnswer:
            self.btnAnswer.isHidden = true
            self.btnEndCall.isHidden = false
            self.centerBtnEndConstraint.constant = 0
            self.lblTime.text = "Đang đổ chuông"
            break
        case .incommingCall:
            break
        }
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
