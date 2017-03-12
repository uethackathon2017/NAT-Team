//
//  HomeViewModel.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation
import SwiftMessages
import AVFoundation

class HomeViewModel {
    struct CellDescription {
        var title: String = ""
        var image: String = ""
    }
    
    var listCell: [CellDescription] = [
        CellDescription(title: "Bắt đầu trò chuyện", image: "home_body"),
        CellDescription(title: "Lịch sử", image: "home_record"),
        CellDescription(title: "Chat với người bản xứ", image: "home_chat"),
        CellDescription(title: "Kết quả học tập", image: "home_resource")
    ]
    
    func newClient(completeHandle:(()->())?){
        SocketRequest.share.login { 
            completeHandle?()
        }
    }
    
    func onGetNewMessage(complite: @escaping (_ mess: Messenger)->Void){
        SocketRequest.share.appSocket.off(SocketEvent.SEND_MESSAGE)
        SocketRequest.share.appSocket.on(SocketEvent.SEND_MESSAGE) { [weak self] (data, ack) in
            //Test self push noti
            
            if let data = data.first as? NSDictionary{
                let res = ResObject(dictionary: data)
                if let data = res.data{
                    let mess = Messenger(dictionary: data)
                    complite(mess)
                }
            }
        }
    }
    
    func showAlert( mess: Messenger, tapHandle: @escaping ()->Void){
        let view = MessageView.viewFromNib(layout: .CardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        if let conten = mess.content {
            view.configureContent(body: conten)
            
        }
        
        view.configureTheme(backgroundColor: UIColor.white, foregroundColor: AppDefine.AppColor.pink)
        view.titleLabel?.text = mess.full_name
        
        if let avatar = mess.avatar {
            view.iconImageView?.kf.setImage(with: URL(string: avatar))
        }
        
        view.button?.isHidden = true
        view.tapHandler = { (base) in
            tapHandle()
            SwiftMessages.hide()
        }
        // Show the message.
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        config.duration = .seconds(seconds: 3)
        let systemSoundID: SystemSoundID = 1007
        AudioServicesPlaySystemSound (systemSoundID)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        SwiftMessages.show(config: config, view: view)
    }
    
}
