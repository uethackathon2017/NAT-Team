//
//  VideoCallManager.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import SocketIO
import EVReflection

class VideoCallManager {
    
    ///Event
    enum Event: String {
        case callRequest = "call"
        case callCancel = "cancel-call"
        case callStatus = "answer"
    }
    
    enum Status: String {
        case none
        case decline = "Từ chối"
        case timeout = "Không nghe máy"
        case notConnect = "Không thể kết nối"
        case systemError
    }
    
    /// Instance
    static var share = VideoCallManager()
    
    var client = SocketRequest.share.appSocket
    var callRequest = CallRequestResponse()
    
    // MARK: - Listen
    func startReceiveCall(completeHandle:(()->())?) {
        client.off(Event.callRequest.rawValue)
        SocketRequest.share.appSocket.on(VideoCallManager.Event.callRequest.rawValue) { (data, ack) in
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data {
                    let request = CallRequestResponse(dictionary: data, conversionOptions: ConversionOptions.KeyCleanup, forKeyPath: nil)
                    self.callRequest = request
                    completeHandle?()
                }
            }
        }
    }
    
    func stopReceiveCall() {
        client.off(Event.callRequest.rawValue)
    }
    
    func listenCallDrop(completeHandle:(()->())?) {
        client.off(Event.callCancel.rawValue)
        client.on(Event.callCancel.rawValue) { (data, ack) in
            completeHandle?()
        }
    }
    
    func stopListenCallDrop() {
        client.off(Event.callCancel.rawValue)
    }
    
    func listenCallStatus(completeHandle:((Status)->())?) {
        client.off(Event.callStatus.rawValue)
        client.on(Event.callStatus.rawValue) { (data, ack) in
            var status: Status = .none
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let code = res.error_code {
                    if code == "151" {
                        status = Status.decline
                    } else if code == "152" {
                        status = Status.timeout
                    } else if code == "100" {
                        status = Status.systemError
                    } else if code == "150" {
                        status = Status.notConnect
                    }
                }
            }
            completeHandle?(status)
        }
    }
    
    func stopListenCallStatus() {
        client.off(Event.callStatus.rawValue)
    }
    
    // MARK: - Emit
    func makeCallRequest(request: CallRequestResponse) {
        self.callRequest = request
        let param: [String: Any] = [
            "room_id": request.roomId?.intValue ?? "",
            "call_id": request.callID?.intValue ?? "",
            "receiver_id": request.receiverId ?? "",
            "hasVideo": request.hasVideo?.intValue ?? ""
        ]
        print(param)
        let ack = self.client.emitWithAck(Event.callRequest.rawValue, param)
        ack.timingOut(after: 10) { (data) in
            print(data)
        }
    }
    
    func dropCall() {
        self.client.emit(Event.callCancel.rawValue, [])
    }
    
    func responseCall(accept: Bool) {
        let param = [
            "room_id": self.callRequest.roomId?.intValue ?? -1,
            "accept": accept ? 1 : 0
        ]
        self.client.emit(Event.callStatus.rawValue, param)
    }
    
}

class CallRequestResponse: EVObject {
    var roomId: NSNumber?
    var callID: NSNumber?
    var receiverId: String?
    var hasVideo: NSNumber?
    var avatar: String?
    var fullName: String?
}
