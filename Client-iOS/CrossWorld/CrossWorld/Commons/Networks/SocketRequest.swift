////
////  SocketRequest.swift
////  socket
////
////  Created by My Macbook Pro on 2/7/17.
////  Copyright © 2017 My Macbook Pro. All rights reserved.
////
//
//import Foundation
//import SocketIO
//import CoreLocation
//
//class SocketEvent {
//    static let NEW_CLIENT = "new-client"
//    static let GET_DRIVE_LOCATION = "send-driver-location"
//    static let BOOKING = "booking" // Send request booking
//    static let DRIVER_INFO = "driver-detail"
//    static let CANCLE_TRIP = "cancel_booking"
//    static let BOOKING_RESPONSE = "booking" // listen when did booking complite
//    static let DRIVER_COMING_LOCATIN = "coming-coordinate"// listen when start trip
//    static let TRIP_LOCATON = "journey-coordinate"
//    static let ON_STOP_TRIP = "stop-journey" //listen when complite trip
//    static let RATING = "rating" //rating driver when complite
//}
//
//class SocketRequest {
//    static let share = SocketRequest()
//    var listEventOnListen = [String]()
//    var isOffDriverLocation = false
//    
//    let appSocket = SocketIOClient(socketURL: URL(string: Domain.DOMAIN_HTTP_SOCKET)!, config: [.log(false), .forcePolling(true), .reconnects(true), .connectParams(["token" : User.share.token ?? "0"]) ])
//    
//    func onError()  {
//        appSocket.on("error") { (data, ack) in
//            print("Error ________________________________\(data)")
//        }
//    }
//    
//    func onAuth(){
//        connectToSocketToEmit {
//            self.appSocket.on("auth", callback: { (data, ack) in
//                
//                print("Auth ________________________________\(data)")
//            })
//        }
//    }
//    
//    func onDisconect(){
//        appSocket.on("disconnect") { (data, ack) in
//            print("Disconnect ________________________________\(data)")
//            self.appSocket.reconnect()
//        }
//    }
//    
//    func onReconnect(){
//        appSocket.on("reconnect") { (data, ack) in
//            print("Reconnect ________________________________\(data)")
//        }
//    }
//    
//    func onConnect(){
//        appSocket.on("connect") { (data, ack) in
//            print("Connect ________________________________\(data)")
//        }
//    }
//    
//    func onReconnectAttempt(){
//        appSocket.on("reconnectAttempt") { (data, ack) in
//            print("ReconnectAttempt ________________________________\(data)")
//        }
//    }
//    
//    
//    //connect
//    func connectToSocketToEmit(handle: @escaping ()->()){
//        if !isInternetAvailable() {
//            openWifiSetting()
//        }else{
//            if appSocket.status == SocketIOClientStatus.connected {
//                handle()
//            }else if appSocket.status == SocketIOClientStatus.connecting{
//                appSocket.once("connect", callback: { (res, data) in
//                    handle()
//                })
//            
//            }else if appSocket.status == SocketIOClientStatus.notConnected {
//                appSocket.connect()
//                appSocket.once("connect", callback: { (res, data) in
//                    handle()
//                })
//            }else if appSocket.status == SocketIOClientStatus.disconnected {
//                appSocket.reconnect()
//                appSocket.once("reconnect", callback: { (res, ack) in
//                    print("reconnect ________________________________\(res)")
//                    handle()
//                })
//            }else{
//                fatalError("Check your status")
//            }
//        }
//    }
//    
//    func onListen(event: String, handle: @escaping (_ data: NSDictionary)->()){
//        if !isInternetAvailable() {
//            openWifiSetting()
//        }else{
//            for item in self.listEventOnListen{
//                if item == event{
//                    
//                    print("Event \(event) did on litening")
//                    return
//                }
//            }
//            
//            self.listEventOnListen.append(event)
//            connectToSocketToEmit {
//                self.appSocket.off(event)
//                self.handleSocketCallback(event: event, handle: { (data) in
//                    handle(data)
//                })
//            }
//            
//            self.appSocket.on("disconnect", callback: { (res, ack) in
//                
//                if self.listEventOnListen.index(of: event) != nil {
//                    self.appSocket.off(event)
//                    self.appSocket.reconnect()
//                }
//            })
//            
//            self.appSocket.on("reconnect", callback: { (res, ack) in
//                
//                if self.listEventOnListen.index(of: event) != nil {
//                    self.handleSocketCallback(event: event, handle: { (data) in
//                        handle(data)
//                    })
//                }
//            })
//        }
//    }
//    
//    func handleSocketCallback(event: String, handle: @escaping (_ data: NSDictionary)-> Void){
//        
//        if self.listEventOnListen.index(of: event) != nil {
//            
//            self.appSocket.on(event, callback: { (data, ack) in
//                if let data = data.first as? NSDictionary{
//                    handle(data)
//                }
//            })
//        }else{
//            appSocket.off(event)
//        }
//    }
//    
//
//    func login(){ // Client connect socket and sent custom_id when login
//        self.onError()
//        self.onDisconect()
//        self.onReconnect()
//        self.onReconnectAttempt()
//        self.onConnect()
//        self.appSocket.connect()
//        connectToSocketToEmit {
//            let param : NSDictionary = [
//                "customer_id": User.share.customer_id!
//            ]
//            
//            self.onAuth()
//            self.appSocket.emitWithAck(SocketEvent.NEW_CLIENT, param).timingOut(after: 5, callback: { (data) in
//                
//            })
//        }
//        
//        self.appSocket.on("reconnect", callback: { (res, ack) in
//            self.connectToSocketToEmit{
//                let param : NSDictionary = [
//                    "customer_id": User.share.customer_id!
//                ]
//                
//                self.onAuth()
//                self.appSocket.emitWithAck(SocketEvent.NEW_CLIENT, param).timingOut(after: 5, callback: { (data) in
//                    
//                })
//
//            }
//        })
//    }
//    
//    func sendUserLocation(location: CLLocationCoordinate2D, handle: (()->())?){
//        
//        connectToSocketToEmit {
//            let param: NSDictionary = [
//                "customer_id" : User.share.customer_id!,
//                "location": "\(location.latitude) \(location.longitude)"
//            ]
//            self.appSocket.emitWithAck(SocketEvent.GET_DRIVE_LOCATION, param).timingOut(after: 4, callback: { (data) in
//                print(data)
//                if let handleComplite = handle {
//                    handleComplite()
//                }
//            })
//        }
//    }
//    
//    
//    //Get car around user
//    func getDriveLocation(handle: @escaping (_ data: ListCarResponse)->Void){
//        
//        onListen(event: SocketEvent.GET_DRIVE_LOCATION) { (data) in
//            let response = ResObject(dictionary: data)
//            if let dataRespon = response.data {
//                let listCar = ListCarResponse(dictionary: dataRespon)
//                if listCar.list != nil {
//                    handle(listCar)
//                }
//            }
//        }
//        
////        connectToSocketToEmit {
////            self.appSocket.off(SocketEvent.GET_DRIVE_LOCATION)
////            self.appSocket.on(SocketEvent.GET_DRIVE_LOCATION, callback: { (res, SocketAckEmitter) in
////                print("Success_____________________")
////                print(res)
////                if let data = res.first as? NSDictionary{
////                    let response = ResObject(dictionary: data)
////                    if let dataRespon = response.data {
////                        let listCar = ListCarResponse(dictionary: dataRespon)
////                        if listCar.list != nil {
////                            handle(listCar)
////                        }
////                    }
////
////                }
////            })
////        }
//    }
//    //invalid Get Driver Location
//    func offGetDriverLocation(){
//        self.isOffDriverLocation = true
//        self.appSocket.off(SocketEvent.GET_DRIVE_LOCATION)
//        //remove one
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.GET_DRIVE_LOCATION)
//        }
//    }
//    
//    func sendBooking(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, type: String, note:String?, promotion_code: String?, priority_id: Int, payment_id: Int, start_address: String, end_address: String, distance: Double, total_price: Double, handle: ((_ data: NSDictionary)->())?){
//        connectToSocketToEmit {
//            let param: NSDictionary = [
//                "customer_id" : User.share.customer_id!,
//                "vehicle_type": type,
//                "start_point": start.toString(),
//                "end_point": end.toString(),
//                "note": note ?? "",
//                "promotion_code": promotion_code ?? "",
//                "priority_id": priority_id,
//                "payment_id": payment_id,
//                "start_address": start_address,
//                "end_address": end_address,
//                "distance": distance,
//                "total_price": total_price
//            ]
//            self.appSocket.emitWithAck(SocketEvent.BOOKING, param).timingOut(after: 6, callback: { (data) in
//                
//                if let success = data.first as? Bool{
//                    if success {
//                        return
//                    }
//                }
//                AlertView.alert(title: "Error", message: data.description, style: .alert).willCancel().show()
//            })
//        }
//    }
//    
//    func getBookingResponse(handle: @escaping (_ isSuccess: Bool, _ data: Driver?)->Void){
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.BOOKING)
//            self.appSocket.on(SocketEvent.BOOKING, callback: { (res, ack) in
//                
//                if let data = res.first as? NSDictionary{
//                    ack.with("Callback Success")
//                    ResObject.handleDataResponse(data: data, handle: { (isSuccess, datares) in
//                        if isSuccess {
//                            let driver = Driver(dictionary: datares!)
//                            handle(true, driver)
//                            self.appSocket.off(SocketEvent.BOOKING)
//                        }
//                    }, handleError: { (res) in
//                        if res.error_code == "150"{
//                            handle(false, nil)
//                        }else{
//                            AlertView.alert(title: res.error_code, message: res.message, style: .alert).willCancel().show()
//                            handle(false, nil)
//                        }
//                    })
//                    
//                }else{
//                    AlertView.alert(title: "Error", message: res.description, style: .alert).willCancel().show()
//                    handle(false, nil)
//                }
//            })
//        }
//    }
//    
//    //SOCKET: Lấy toạ độ driver đang đến đón khách
//    func getDriverComingLocaion(handle: @escaping (_ isSuccess: Bool, _ data: TripLocation?)->Void){
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.DRIVER_COMING_LOCATIN)
//            self.appSocket.on(SocketEvent.DRIVER_COMING_LOCATIN, callback: { (res, ack) in
//                
//                if let data = res.first as? NSDictionary{
//                    ack.with("Callback Success")
//                    ResObject.handleDataResponse(data: data, handle: { (isSuccess, datares) in
//                        if isSuccess {
//                            let trip = TripLocation(dictionary: datares!)
//                            handle(true, trip)
//                        }
//                    }, handleError: { (res) in
//                        
//                        AlertView.alert(title: res.error_code, message: res.message, style: .alert).willCancel().show()
//                        handle(false, nil)
//                        
//                    })
//                    
//                }else{
//                    AlertView.alert(title: "Error", message: res.description, style: .alert).willCancel().show()
//                    handle(false, nil)
//                }
//            })
//        }
//    }
//    
//    func offDriverComing(){
//        self.appSocket.off(SocketEvent.DRIVER_COMING_LOCATIN)
//    }
//    
//    //SOCKET: Lấy tọa độ chuyến đi
//    func getTripLocation(handle: @escaping (_ isSuccess: Bool, _ data: TripLocation?)->Void){
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.TRIP_LOCATON)
//            self.appSocket.on(SocketEvent.TRIP_LOCATON, callback: { (res, ack) in
//                
//                if let data = res.first as? NSDictionary{
//                    ack.with("Callback Success")
//                    ResObject.handleDataResponse(data: data, handle: { (isSuccess, datares) in
//                        if isSuccess {
//                            let trip = TripLocation(dictionary: datares!)
//                            handle(true, trip)
//                        }
//                    }, handleError: { (res) in
//                        
//                        AlertView.alert(title: res.error_code, message: res.message, style: .alert).willCancel().show()
//                        handle(false, nil)
//                        
//                    })
//                    
//                }else{
//                    AlertView.alert(title: "Error", message: res.description, style: .alert).willCancel().show()
//                    handle(false, nil)
//                }
//            })
//        }
//    }
//    
//    func compliteTrip(handle: @escaping (_ isSuccess: Bool, _ data: CompliteTrip?)->Void){
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.ON_STOP_TRIP)
//            self.appSocket.on(SocketEvent.ON_STOP_TRIP, callback: { (res, ack) in
//                if let data = res.first as? NSDictionary{
//                    ack.with("Callback Success")
//                    ResObject.handleDataResponse(data: data, handle: { (isSuccess, datares) in
//                        if isSuccess {
//                            let complite = CompliteTrip(dictionary: datares!)
//                            handle(true, complite)
//                        }
//                    }, handleError: { (res) in
//                        
//                        AlertView.alert(title: res.error_code, message: res.message, style: .alert).willCancel().show()
//                        handle(false, nil)
//                        
//                    })
//                    
//                }else{
//                    AlertView.alert(title: "Error", message: res.description, style: .alert).willCancel().show()
//                    handle(false, nil)
//                }
//                
//            })
//        }
//    }
//    
//    func ratingDriver(journey_info_id: String, comment: String?, rate: String, handle: (()->())?){
//        connectToSocketToEmit {
//            let param: NSDictionary = [
//                "customer_id" : User.share.customer_id!,
//                "journey_info_id": journey_info_id,
//                "rate": rate,
//                "comment": comment ?? ""
//            ]
//            self.appSocket.emitWithAck(SocketEvent.RATING, param).timingOut(after: 6, callback: { (data) in
//                if let handleComplite = handle {
//                    handleComplite()
//                }
//            })
//        }
//    }
//    
//    func onRatingDriver( handle: @escaping (_ isSuccess: Bool, _ data: NSDictionary?)->Void){
//        connectToSocketToEmit {
//            self.appSocket.off(SocketEvent.RATING)
//            self.appSocket.on(SocketEvent.RATING, callback: { (res, ack) in
//                if let data = res.first as? NSDictionary{
//                    ack.with("Callback Success")
//                    ResObject.handleDataResponse(data: data, handle: { (isSuccess, datares) in
//                        if isSuccess {
//                            handle(true, datares)
//                        }
//                    }, handleError: { (res) in
//                        
//                        AlertView.alert(title: res.error_code, message: res.message, style: .alert).willCancel().show()
//                        handle(false, nil)
//                        
//                    })
//                    
//                }else{
//                    AlertView.alert(title: "Error", message: res.description, style: .alert).willCancel().show()
//                    handle(false, nil)
//                }
//                
//            })
//        }
//    }
//    
//    
//}
//
//extension CLLocationCoordinate2D{
//    
//    func toString()->String{
//        return "\(self.latitude) \(self.longitude)"
//    }
//}
