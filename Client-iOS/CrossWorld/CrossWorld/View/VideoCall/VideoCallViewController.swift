//
//  VideoCallViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import IBAnimatable
import Bond

class VideoCallViewController: AppViewController {

    // MARK: - Outlet
    
    // AppRTC
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    // ActionOutlet
    @IBOutlet weak var btnDropCall: UIButton!
    @IBOutlet weak var btnMute: AnimatableCheckBox!
    @IBOutlet weak var btnVideo: AnimatableCheckBox!
    
    // MARK: - Declare
    
    var roomName: String!
    var client: ARDAppClient?
    var localVideoTrack: RTCVideoTrack?
    var remoteVideoTrack: RTCVideoTrack?
    
    // MARK: - Define
    
    // MARK: - Setup
    
    override func setupAction() {
        _ = self.btnDropCall.reactive.tap.observeNext { [weak self] in
            self?.disconnect()
            self?.dismiss(animated: true, completion: nil)
        }
        
        _ = self.btnMute.reactive.tap.observeNext { [weak self] in
            if let clearSelf = self {
                if clearSelf.btnMute.checked {
                    clearSelf.client?.muteAudioIn()
                } else {
                    clearSelf.client?.unmuteAudioIn()
                }
            }
        }
        
        _ = self.btnVideo.reactive.tap.observeNext { [weak self] in
            if let clearSelf = self {
                if clearSelf.btnVideo.checked {
                    clearSelf.client?.muteVideoIn()
                } else {
                    clearSelf.client?.unmuteVideoIn()
                }
            }
        }
    }
    
    override func setupViewController() {
        self.typeViewController = .present
        self.typeNavigationBar = .hidden
    }
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        connectToChatRoom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
    }

}

// MARK: - RTC

extension VideoCallViewController: ARDAppClientDelegate, RTCEAGLVideoViewDelegate {
    //    MARK: RTCEAGLVideoViewDelegate
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state{
        case ARDAppClientState.connected:
            print("Client Connected")
            break
        case ARDAppClientState.connecting:
            print("Client Connecting")
            break
        case ARDAppClientState.disconnected:
            print("Client Disconnected")
            remoteDisconnected()
        }
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        self.localVideoTrack = localVideoTrack
        self.localVideoTrack?.add(localView)
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack?.add(remoteView)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        //        Handle the error
        showAlertWithMessage(error.localizedDescription)
        disconnect()
    }
    
    //    MARK: RTCEAGLVideoViewDelegate
    
    func videoView(_ videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        
    }
    
    //    MARK: Private
    
    func initialize(){
        disconnect()
        //        Initializes the ARDAppClient with the delegate assignment
        client = ARDAppClient.init(delegate: self)
        
        //        RTCEAGLVideoViewDelegate provides notifications on video frame dimensions
        remoteView.delegate = self
        localView.delegate = self
        client?.enableSpeaker()
    }
    
    func connectToChatRoom(){
        client?.serverHostUrl = "https://apprtc.appspot.com"
        client?.connectToRoom(withId: "2468101", options: nil)
    }
    
    func remoteDisconnected(){
        if(remoteVideoTrack != nil){
            remoteVideoTrack?.remove(remoteView)
        }
        remoteVideoTrack = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func disconnect(){
        if(client != nil){
            if(localVideoTrack != nil){
                localVideoTrack?.remove(localView)
            }
            if(remoteVideoTrack != nil){
                remoteVideoTrack?.remove(remoteView)
            }
            localVideoTrack = nil
            remoteVideoTrack = nil
            client?.disconnect()
        }
    }
    
    func showAlertWithMessage(_ message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
