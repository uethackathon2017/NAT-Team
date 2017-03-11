 //
//  SocketRequest.swift
//  socket
//
//  Created by My Macbook Pro on 2/7/17.
//  Copyright © 2017 My Macbook Pro. All rights reserved.
//

import Foundation
import SocketIO
import CoreLocation
import Alamofire

class SocketEvent {
    static let NEW_CLIENT = "new-user"
    static let GET_ALL_ROOM = "get-all-room"
    static let CHAT_ROOM_DETAIL = "chat-history"
    
    static let SEND_MESSAGE = "send-message"
    static let CANCLE_TRIP = "cancel_booking"
    static let BOOKING_RESPONSE = "booking" // listen when did booking complite
    static let DRIVER_COMING_LOCATIN = "coming-coordinate"// listen when start trip
    static let TRIP_LOCATON = "journey-coordinate"
    static let ON_STOP_TRIP = "stop-journey" //listen when complite trip
    static let RATING = "rating" //rating driver when complite
}

class SocketRequest {
    static let share = SocketRequest()
    var listEventOnListen = [String]()
    
    let appSocket = SocketIOClient(socketURL: URL(string: Domain.DOAMIN_SOCKET)!, config: [.log(true), .forcePolling(true), .reconnects(true), .doubleEncodeUTF8(true) ])
    
    func onError()  {
        appSocket.on("error") { (data, ack) in
            print("Error ________________________________\(data)")
        }
    }
    
    func onAuth(){
        connectToSocketToEmit {
            self.appSocket.on("auth", callback: { (data, ack) in
                
                print("Auth ________________________________\(data)")
            })
        }
    }
    
    func onDisconect(){
        appSocket.on("disconnect") { (data, ack) in
            print("Disconnect ________________________________\(data)")
            self.appSocket.reconnect()
        }
    }
    
    func onReconnect(){
        appSocket.on("reconnect") { (data, ack) in
            print("Reconnect ________________________________\(data)")
        }
    }
    
    func onConnect(){
        appSocket.on("connect") { (data, ack) in
            print("Connect ________________________________\(data)")
        }
    }
    
    func onReconnectAttempt(){
        appSocket.on("reconnectAttempt") { (data, ack) in
            print("ReconnectAttempt ________________________________\(data)")
        }
    }
    
    
    //connect
    func connectToSocketToEmit(handle: @escaping ()->()){
        if !isInternetAvailable() {
            openWifiSetting()
        }else{
            if appSocket.status == SocketIOClientStatus.connected {
                handle()
            }else if appSocket.status == SocketIOClientStatus.connecting{
                appSocket.once("connect", callback: { (res, data) in
                    handle()
                })
            
            }else if appSocket.status == SocketIOClientStatus.notConnected {
                appSocket.connect()
                appSocket.once("connect", callback: { (res, data) in
                    handle()
                })
            }else if appSocket.status == SocketIOClientStatus.disconnected {
                appSocket.reconnect()
                appSocket.once("reconnect", callback: { (res, ack) in
                    print("reconnect ________________________________\(res)")
                    handle()
                })
            }else{
                fatalError("Check your status")
            }
        }
    }
    
    func onListen(event: String, handle: @escaping (_ data: NSDictionary)->()){
        if !isInternetAvailable() {
            openWifiSetting()
        }else{
            for item in self.listEventOnListen{
                if item == event{
                    
                    print("Event \(event) did on litening")
                    return
                }
            }
            
            self.listEventOnListen.append(event)
            connectToSocketToEmit {
                self.appSocket.off(event)
                self.handleSocketCallback(event: event, handle: { (data) in
                    handle(data)
                })
            }
            
            self.appSocket.on("disconnect", callback: { (res, ack) in
                
                if self.listEventOnListen.index(of: event) != nil {
                    self.appSocket.off(event)
                    //self.appSocket.reconnect()
                }
            })
            
            self.appSocket.on("reconnect", callback: { (res, ack) in
                
                if self.listEventOnListen.index(of: event) != nil {
                    self.appSocket.off(event)
                    self.handleSocketCallback(event: event, handle: { (data) in
                        handle(data)
                    })
                }
            })
        }
    }
    
    func handleSocketCallback(event: String, handle: @escaping (_ data: NSDictionary)-> Void){
        
        if self.listEventOnListen.index(of: event) != nil {
            
            self.appSocket.on(event, callback: { (data, ack) in
                print(data)
                if let data = data.first as? NSDictionary{
                    handle(data)
                }
            })
        }else{
            appSocket.off(event)
        }
    }
    

    func login(){ // Client connect socket and sent custom_id when login
        self.onError()
        self.onDisconect()
        self.onReconnect()
        self.onReconnectAttempt()
        self.onConnect()
        self.appSocket.connect()
        
        self.appSocket.on("connect", callback: { (res, ack) in
            print("Resent new client")
            self.connectToSocketToEmit{
                let param : NSDictionary = [
                    "user_id": User.current.user_id!
                ]
                
                self.appSocket.emitWithAck(SocketEvent.NEW_CLIENT, param).timingOut(after: 5, callback: { (data) in
                    print("new client \(data)")
                })
                
            }
        })
        
//        self.appSocket.on("reconnect", callback: { (res, ack) in
//            print("Resent new client")
//            self.connectToSocketToEmit{
//                let param : NSDictionary = [
//                    "user_id": User.current.user_id!
//                ]
//                
//                self.appSocket.emitWithAck(SocketEvent.NEW_CLIENT, param).timingOut(after: 5, callback: { (data) in
//                    print("new client \(data)")
//                })
//
//            }
//        })
    }
    
    func sendGetAllRoom( handle: (()->())?){
        
        connectToSocketToEmit {
            let param: NSDictionary = [
                "user_id" : User.current.user_id!
            ]
            self.appSocket.emitWithAck(SocketEvent.GET_ALL_ROOM, param).timingOut(after: 5, callback: { (data) in
                print(data)
                if let handleComplite = handle {
                    handleComplite()
                }
            })
        }
    }
    
    func onGetAllRoom(handle: @escaping ((_ isSuccess: Bool, _ data: NSDictionary)->())){
        onListen(event: SocketEvent.GET_ALL_ROOM) { (data) in
            handle(true, data)
        }
    }
    
    func sendGetRoomDetail(room_id: String, page: String?, handle: (()->())?){
        
        connectToSocketToEmit {
            var param: Parameters = [
                "room_id" : room_id
            ]
            if let pageCheck = page{
                param["page"] = pageCheck
            }
            
            self.appSocket.emitWithAck(SocketEvent.CHAT_ROOM_DETAIL, param).timingOut(after: 5, callback: { (data) in
                print(data)
                if let handleComplite = handle {
                    handleComplite()
                }
            })
        }
    }
    
    func onGetRoomDetail(handle: @escaping ((_ isSuccess: Bool, _ data: NSDictionary)->())){
        onListen(event: SocketEvent.CHAT_ROOM_DETAIL) { (data) in
            
            handle(true, data)
        }
    }


}

extension CLLocationCoordinate2D{
    
    func toString()->String{
        return "\(self.latitude) \(self.longitude)"
    }
}
