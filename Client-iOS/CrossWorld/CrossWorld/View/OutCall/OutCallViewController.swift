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
import Kingfisher

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
        case requestIncommingVideo
    }
    var popup = PopupController()
    var callState: CallState = .incommingCall {
        didSet {
//            setupUI()
        }
    }
    
    var isAccept: Bool = false
    var displayTimer = Timer()
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if callState == .requestIncommingCall || callState == .requestIncommingVideo {
            SoundManager.share.playSoundIncommingCall()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if callState == .requestIncommingCall || callState == .requestIncommingVideo {
            SoundManager.share.stopSoundBooking()
        }
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
        
        // Info
        self.imgAvatar.kf.setImage(with: URL(string: VideoCallManager.share.callRequest.avatar ?? ""))
        self.lblName.text = VideoCallManager.share.callRequest.fullName
        
        switch callState {
        case .requestIncommingVideo:
            self.btnAnswer.isHidden = false
            self.btnEndCall.isHidden = false
            self.centerBtnAnswerConstraint.constant = -90
            self.centerBtnEndConstraint.constant = 90
            self.lblTime.text = "Cuộc gọi video"
            VideoCallManager.share.listenCallDrop { [weak self] in
                VideoCallManager.share.stopListenCallDrop()
                self?.popup.dismiss({ 
                    //
                })
            }
            break
        case .requestIncommingCall:
            self.btnAnswer.isHidden = false
            self.btnEndCall.isHidden = false
            self.centerBtnAnswerConstraint.constant = -90
            self.centerBtnEndConstraint.constant = 90
            self.lblTime.text = "Cuộc gọi thoại"
            VideoCallManager.share.listenCallDrop { [weak self] in
                VideoCallManager.share.stopListenCallDrop()
                self?.popup.dismiss({
                    //
                })
            }
            break
        case .waitingAnswer:
            self.btnAnswer.isHidden = true
            self.btnEndCall.isHidden = false
            self.centerBtnEndConstraint.constant = 0
            self.lblTime.text = "Đang đổ chuông"
            VideoCallManager.share.listenCallStatus(completeHandle: { [weak self] (status) in
                guard self != nil else {
                    return
                }
                if status == VideoCallManager.Status.decline {
                    self?.lblTime.text = "Từ chối"
                    self?.displayTimer = Timer.scheduledTimer(timeInterval: 2, target: self!, selector: #selector(self?.dismissPopup), userInfo: nil, repeats: false)
                } else if status == VideoCallManager.Status.notConnect {
                    self?.lblTime.text = "Không kết nối"
                    self?.displayTimer = Timer.scheduledTimer(timeInterval: 2, target: self!, selector: #selector(self?.dismissPopup), userInfo: nil, repeats: false)
                } else if status == VideoCallManager.Status.timeout {
                    self?.lblTime.text = "Không trả lời"
                    self?.displayTimer = Timer.scheduledTimer(timeInterval: 2, target: self!, selector: #selector(self?.dismissPopup), userInfo: nil, repeats: false)
                } else if status == VideoCallManager.Status.none {
                    self?.isAccept = true
                    self?.popup.dismiss()
                }
            })
            break
        case .incommingCall:
            break
        }
    }
    
    override func setupAction() {
        _ = self.btnEndCall.reactive.tap.observeNext { [weak self] in
            if self?.callState == .requestIncommingCall || self?.callState == .requestIncommingVideo {
                VideoCallManager.share.responseCall(accept: false)
            } else if self?.callState == .waitingAnswer {
                VideoCallManager.share.dropCall()
            }
            self?.popup.dismiss()
        }
        
        _ = self.btnAnswer.reactive.tap.observeNext { [weak self] in
            if self?.callState == .requestIncommingCall {
                VideoCallManager.share.responseCall(accept: true)
                self?.isAccept = true
            } else if self?.callState == .waitingAnswer {
                //
            } else if self?.callState == .requestIncommingVideo {
                VideoCallManager.share.responseCall(accept: true)
                self?.isAccept = true
            }
            self?.popup.dismiss()
        }
    }
    
    // MARK: - Popup
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return AppDefine.Define.sizeOfScreen
    }
    
    // MARK: - Action
    func dismissPopup() {
        self.popup.dismiss()
    }

}
