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
    var listMessenger = Messenger().fakeListMessage()
    var firstOpen = true
    var pathSequece = true
    var isFriend = true

    
    // MARK: - Define
    let refreshControl = UIRefreshControl()
    let imagePickerController = ImagePickerController()
    
    // MARK: - Setup
    func setup(){
        tvMessage.delegate = self
        imagePickerController.delegate = self
        
        //Keyboard show hide notification register
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillShown(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableMessage()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupViewController() {
        typeNavigationBar = .normal
        leftButtonType = .back
        rightButtonType = .notification
        self.title = AppDefine.Screen.chat
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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MessageViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tbMessage.addSubview(refreshControl)
    }
    
    func refresh(_ sender:AnyObject){
        //loadMoreMessenger()
        refreshControl.endRefreshing()
    }
    
    
    func sentNewMessage(_ content: String){
        
        //        let param = ["timestamp": FIRServerValue.timestamp(), "content": content, "sendBy": unwrappingThisString(User.sharedInstance.userId)] as [String : Any]
        //
        //        ref.child("messenger").child(self.pathMessage!).childByAutoId().setValue(param)
        //        updateLastMessenger(content)
    }
    
    //MARK: - Keyboard
    func keyboardWillShown(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintViewBottom.constant = keyboardFrame.size.height
            self.constrainTableViewBottom.constant = self.constrainTableViewBottom.constant + keyboardFrame.size.height
            self.view.layoutIfNeeded()
            
        }, completion: { (completion) in
            if self.listMessenger.count > 0{
                self.tbMessage.scrollToRow(at: IndexPath(row: self.listMessenger.count - 1, section: 0), at: UITableViewScrollPosition.none, animated: true);
            }
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.constraintViewBottom.constant = 0;
            self.constrainTableViewBottom.constant = 60
            self.view.layoutIfNeeded();
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        self.tvMessage.resignFirstResponder()
    }
    
    @IBAction func btnSendClick(_ sender: AnyObject) {
        
        let mess = Messenger(content: self.tvMessage.text)
        self.listMessenger.append(mess)
        self.tbMessage.reloadData()
        sentNewMessage(tvMessage.text)
        
        tvMessage.resignFirstResponder()
        if !self.tvMessage.text.isEmpty {
            self.tvMessage.text = nil
            changeSizeTextViewInput()
            var row = 0
            if self.listMessenger.count != 0 {
                row = self.listMessenger.count - 1
            }
            self.tbMessage.scrollToRow(at: IndexPath.init(row: row, section: 0), at: UITableViewScrollPosition.bottom, animated: true);
        }
    }
    @IBAction func btnFileClick(_ sender: AnyObject) {
        
        self.present(imagePickerController, animated: true, completion: nil)

    }
    // MARK: - UITextView Delegate
    // MARK: - UITableView Delegate, Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessenger.count
    }
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 61
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LeftChatCell{
            cell.lbTime.isHidden = true
        }
        
        if let cell = cell as? RightChatCell{
            // cell.constrainLbTimeWidth.constant = 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listMessenger[indexPath.row]
        if !item.wasWritebyMe {
            let leftCell = tableView.dequeueReusableCell(withIdentifier: "LeftChatCell", for: indexPath) as! LeftChatCell
            leftCell.lbReceiveMsg.text = item.content
            leftCell.imgAvatar.backgroundColor = UIColor.blue
            return leftCell
        }else{
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "RightChatCell", for: indexPath) as! RightChatCell
            rightCell.lbSenderMsg.text = item.content
            rightCell.imgAvatar.backgroundColor = UIColor.green
            return rightCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        
        if let cell = tbMessage.cellForRow(at: indexPath) as? LeftChatCell {
            cell.showMessageTime()
        }
        
    }
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    //        footerView.backgroundColor = UIColor.white
    //        return footerView
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 61
    //    }
    
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
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
}
