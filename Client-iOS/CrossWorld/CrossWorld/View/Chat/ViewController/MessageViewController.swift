//
//  MessageViewController.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import ImagePicker

class MessageViewController: AppViewController , UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ImagePickerDelegate {
    // MARK: - Outlet
    @IBOutlet weak var constrainTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constrainTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tbMessage: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tvMessage: UITextView!
    
    
    // MARK: - Declare
    
    var firstOpen = true
    var pathSequece = true
    var isFriend = true
    var room = RoomDetail()
    
    // MARK: - Define
    let refreshControl = UIRefreshControl()
    let imagePickerController = ImagePickerController()
    var viewModel = ChatViewModel()
    
    // MARK: - Setup
    func setup(){
        tvMessage.delegate = self
        imagePickerController.delegate = self
        
        //Keyboard show hide notification register
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillShown(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getData(){
        self.startAnimating()
        viewModel.sendGetMessage(room_id: "\(room.room_id!.intValue)", page: "1") {
            
        }
        
        viewModel.onGetNewMessage { (isSucees) in
            if isSucees{
                self.tbMessage.reloadData()
                if self.viewModel.listMessenger.count != 0 {
                    self.tbMessage.scrollToRow(at: IndexPath(row: (self.viewModel.listMessenger.count) - 1, section: 0), at: UITableViewScrollPosition.middle, animated: false)
                    
                }
            }else{
                
            }
        }
        
        viewModel.onGetMessage { [weak self] (isSuccess) in
            self?.stopAnimating()
            if isSuccess{
                self?.tbMessage.reloadData()
                if self?.viewModel.listMessenger.count != 0 {
                    self?.tbMessage.scrollToRow(at: IndexPath(row: (self?.viewModel.listMessenger.count)! - 1, section: 0), at: UITableViewScrollPosition.middle, animated: false)
                }
            }else{
                print("fail")
            }
        }
    }
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableMessage()
        setup()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.listMessenger.count != 0 {
            self.tbMessage.scrollToRow(at: IndexPath(row: self.viewModel.listMessenger.count - 1, section: 0), at: UITableViewScrollPosition.middle, animated: false)
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        self.viewModel = ChatViewModel()
        print("====denit")
    }
    
    override func setupViewController() {
        typeNavigationBar = .normal
        leftButtonType = .back
        rightButtonType = .call
        if let title = room.full_name{
            self.title = title
        }else{
            self.title = AppDefine.Screen.chat
            
        }
    }
    
    override func leftNaviButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func initTableMessage(){
        tbMessage.estimatedRowHeight = 61
        tbMessage.rowHeight = UITableViewAutomaticDimension
        //self.automaticallyAdjustsScrollViewInsets = false
        tbMessage.separatorColor = UIColor.clear
        
        //pull to refresh tableView
        refreshControl.attributedTitle = NSMutableAttributedString().normal("Load more", color: AppDefine.AppColor.pink)
        refreshControl.addTarget(self, action: #selector(MessageViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tbMessage.addSubview(refreshControl)
    }
    
    func refresh(_ sender:AnyObject){
        //loadMoreMessenger()
        refreshControl.endRefreshing()
    }
    
    
    //MARK: - Keyboard
    func keyboardWillShown(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintViewBottom.constant = keyboardFrame.size.height
            self.constrainTableViewBottom.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
            
        }, completion: { [weak self] (completion) in
            guard self != nil else {
                return
            }
            if self!.viewModel.listMessenger.count > 0{
                self!.tbMessage.scrollToRow(at: IndexPath(row: self!.viewModel.listMessenger.count - 1, section: 0), at: UITableViewScrollPosition.none, animated: true);
            }
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.constraintViewBottom.constant = 0;
                self.constrainTableViewBottom.constant = 0
                self.view.layoutIfNeeded();
            })
        }
    }
    
    
    @IBAction func btnSendClick(_ sender: AnyObject) {
        
        sentNewMessage(tvMessage.text)
        
        tvMessage.resignFirstResponder()
        if !self.tvMessage.text.isEmpty {
            self.tvMessage.text = nil
            changeSizeTextViewInput()
        }
    }
    
    func sentNewMessage(_ content: String){
        //Animation when sending
        viewModel.sendNewMessage(room_id: (self.room.room_id?.stringValue)!, meesage: content) { (isSuccess) in
            let mess = Messenger()
            mess.content = content
            mess.sender = User.current.user_id
            mess.time = Date().string()
            
            if isSuccess{
                mess.wasSendFail = true
            }else{
                mess.wasSendFail = false
            }
            self.viewModel.listMessenger.append(mess)
            self.tbMessage.reloadData()
            if self.viewModel.listMessenger.count != 0 {
                self.tbMessage.scrollToRow(at: IndexPath(row: (self.viewModel.listMessenger.count) - 1, section: 0), at: UITableViewScrollPosition.middle, animated: false)
            }
        }
    }
    
    @IBAction func btnFileClick(_ sender: AnyObject) {
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: - UITextView Delegate
    // MARK: - UITableView Delegate, Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listMessenger.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.listMessenger[indexPath.row]
        if item.image != nil || item.photo != nil {
            return 250
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LeftChatCell{
            cell.lbTime.isHidden = true
            cell.imgState.image = nil
        }
        
        if let cell = cell as? RightChatCell{
            
            cell.lbTime.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.listMessenger[indexPath.row]
        if item.sender != User.current.user_id {
            if item.image != nil {
                if let rightImage = tableView.dequeueReusableCell(withIdentifier: "LeftImageTableViewCell", for: indexPath) as? LeftImageTableViewCell{
                    rightImage.imgPhoto.kf.setImage(with: URL(string: item.image!))
                    rightImage.lbTime.text = item.time?.getHourAndMinute()
                    if let avatar = room.avatar {
                        rightImage.imgAvatar.kf.setImage(with: URL(string: avatar))
                    }
                    return rightImage
                }
            }
            
            let leftCell = tableView.dequeueReusableCell(withIdentifier: "LeftChatCell", for: indexPath) as! LeftChatCell
            if let call = item.call_status {
                if call.intValue != 0 {
                    leftCell.lbReceiveMsg.attributedText = NSMutableAttributedString().italic(item.getCallStatus()!, color: UIColor.white)
                }else{
                    leftCell.lbReceiveMsg.text = item.content
                }
            }else{
                leftCell.lbReceiveMsg.text = item.content
            }
           
            leftCell.lbTime.text = item.time?.getHourAndMinute()
            if let avatar = room.avatar {
                leftCell.imgAvatar.kf.setImage(with: URL(string: avatar))
                
            }
            return leftCell
        }else{
            if item.image != nil {
                if let rightImage = tableView.dequeueReusableCell(withIdentifier: "RightImageTableViewCell", for: indexPath) as? RightImageTableViewCell{
                    rightImage.imgPhoto.kf.setImage(with: URL(string: item.image!))
                    rightImage.lbTime.text = item.time?.getHourAndMinute()
                    if let avatar = User.current.avatar{
                        rightImage.imgAvatar.kf.setImage(with: URL(string: avatar))
                    }
                    return rightImage
                }
            }
            
            if item.photo != nil{
                if let rightImage = tableView.dequeueReusableCell(withIdentifier: "RightImageTableViewCell", for: indexPath) as? RightImageTableViewCell{
                    rightImage.imgPhoto.image = item.photo
                    rightImage.lbTime.text = item.time?.getHourAndMinute()
                    if let avatar = User.current.avatar{
                        rightImage.imgAvatar.kf.setImage(with: URL(string: avatar))
                    }
                    return rightImage
                }
            }
            
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "RightChatCell", for: indexPath) as! RightChatCell
            if let call = item.call_status{
                if call.intValue != 0 {
                    rightCell.lbSenderMsg.attributedText = NSMutableAttributedString().italic(item.getCallStatus()!, color: UIColor.red)
                }else{
                    rightCell.lbSenderMsg.text = item.content
                }
            }else{
                rightCell.lbSenderMsg.text = item.content
            }
            
            rightCell.lbTime.text = item.time?.getHourAndMinute()
            if let avatar = User.current.avatar{
                rightCell.imgAvatar.kf.setImage(with: URL(string: avatar))
            }
            
            if indexPath.row == self.viewModel.listMessenger.count - 1 && item.wasSendFail == true {
                rightCell.imgState.image = #imageLiteral(resourceName: "TGMessageUnsentButton")
            }else{
                rightCell.imgState.image = nil
            }
            
            return rightCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        
        if let cell = tbMessage.cellForRow(at: indexPath) as? LeftChatCell {
            cell.showMessageTime()
        }
        
        if let cell = tbMessage.cellForRow(at: indexPath) as? RightChatCell {
            cell.showMessageTime()
        }
        
    }
    
    //MARK: TextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.changeSizeTextViewInput()
        return true
    }
    
    func changeSizeTextViewInput(){
        
        tvMessage.contentSize.height = tvMessage.sizeThatFits(tvMessage.frame.size).height
        
        UIView.animate(withDuration: 0.3) {
            self.constrainTextViewHeight.constant = self.tvMessage.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Image picker delegate
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
        if images.count != 0 {
            for item in images {
                let image = item.resizeImage(newWidth: UIScreen.main.bounds.width)
                let mess = Messenger()
                mess.photo = image
                mess.sender = User.current.user_id
                mess.time = Date().string()
                self.viewModel.listMessenger.append(mess)
                self.tbMessage.reloadData()
                
                self.viewModel.sendNewPhoto(room_id: (self.room.room_id?.stringValue)!, image: image, complite: { (isSuccess) in
                    
                })
            }
        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
}

extension UIImage{
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension MessageViewController {
    override func rightNaviButtonTapped() {
        let request = CallRequestResponse()
        request.avatar = room.avatar
        request.callID = Int(Utils.random9DigitString()) as NSNumber?
        request.roomId = room.room_id
        request.hasVideo = 1
        request.receiverId = room.user_id
        request.fullName = room.full_name
        VideoCallManager.share.makeCallRequest(request: request)
        self.showCall(request: request, callState: OutCallViewController.CallState.waitingAnswer)
    }
}
