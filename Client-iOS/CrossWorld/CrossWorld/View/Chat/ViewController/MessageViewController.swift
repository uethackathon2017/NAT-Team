//
//  MessageViewController.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var constrainTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constrainTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var constraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tbMessage: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tvMessage: UITextView!
    
    //var user: User?
    //var pathMessage: String?
    var listMessenger = Messenger().fakeListMessage()
    //var uid: String? // uid cua nguoi dang chat voi minh
    var firstOpen = true
    let refreshControl = UIRefreshControl()
    var pathSequece = true
    var isFriend = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let name = user?.name {
        //            self.lbUserName.text = name
        //        }else{
        self.lbUserName.text = "some one"
        // }
        //prepareSendNewMessenger(to: uid!)
        initTableMessage()
        
        tvMessage.delegate = self
        //Keyboard show hide notification register
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillShown(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MessageViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        loadMoreMessenger()
        refreshControl.endRefreshing()
    }
    
    func prepareSendNewMessenger(to Uid: String){
        
        //        ref.child("messenger").observeSingleEvent(of: FIRDataEventType.value, with: { (data) in
        //
        //            if let da = data.value as? NSDictionary {
        //                let allKey = da.allKeys
        //                for key in allKey {
        //                    let keyWord = key as! String
        //                    if keyWord.contains(Uid) && keyWord.contains(User.sharedInstance.userId!){
        //                        self.pathMessage = keyWord
        //                        //TODO: load all messenger
        //
        //                        self.pathMessage = keyWord
        //                        //self.loadMessengerFormNow()
        //
        //                    } else{
        //                        if self.pathSequece{
        //                            self.pathMessage = "\(unwrappingThisString(User.sharedInstance.userId))-\(Uid)"
        //
        //                        }else{
        //                            self.pathMessage = "\(Uid)-\(unwrappingThisString(User.sharedInstance.userId))"
        //
        //                        }
        //                    }
        //                }
        //                self.reloadMessengerTable()
        //
        //            }else{
        //                if self.pathSequece{
        //                    self.pathMessage = "\(unwrappingThisString(User.sharedInstance.userId))-\(Uid)"
        //
        //                }else{
        //                    self.pathMessage = "\(Uid)-\(unwrappingThisString(User.sharedInstance.userId))"
        //
        //                }
        //                self.reloadMessengerTable()
        //            }
        //        })
    }
    
    func sentNewMessage(_ content: String){
        
        //        let param = ["timestamp": FIRServerValue.timestamp(), "content": content, "sendBy": unwrappingThisString(User.sharedInstance.userId)] as [String : Any]
        //
        //        ref.child("messenger").child(self.pathMessage!).childByAutoId().setValue(param)
        //        updateLastMessenger(content)
    }
    
    func updateLastMessenger(_ content: String){
        //        if isFriend{
        //            ref.child("users").child(User.sharedInstance.userId!).child("friends").child(uid!).setValue(content)
        //            ref.child("users").child(uid!).child("friends").child(User.sharedInstance.userId!).setValue(content)
        //        }else{
        //            ref.child("users").child(User.sharedInstance.userId!).child("unknowUsers").child(uid!).setValue(content)
        //            ref.child("users").child(uid!).child("unknowUsers").child(User.sharedInstance.userId!).setValue(content)
        //      }
    }
    
    func loadMessengerFormNow(){
        //        let listMessenger: FIRDatabaseQuery = ref.child("messenger").child(self.pathMessage!).queryLimited(toLast: 2)
        //        listMessenger.observeSingleEvent(of: FIRDataEventType.value, with:  { (dataSnapsoft) in
        //            if let data = dataSnapsoft.value as? NSDictionary{
        //                self.listMessenger = Messenger.parseListMessenger(data)
        //                self.reloadMessengerTable()
        //            }
        //        })
    }
    
    func reloadMessengerTable(){
        //        print( " listMessenger count \(listMessenger.count)" )
        //        self.tbMessage.reloadData()
        //
        //        ref.child("messenger").child(pathMessage!).queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) -> Void in
        //            print(snapshot)
        //
        //            if let data = snapshot.value as? NSDictionary{
        //                let item = Messenger.parseNewMesenger(data)
        //                item.id = snapshot.key
        //                self.listMessenger.append(item)
        //                let index = NSIndexPath.init(row: self.listMessenger.count - 1, section: 0)
        //                self.tbMessage.insertRows(at: [index as IndexPath], with: UITableViewRowAnimation.automatic)
        //                self.tbMessage.scrollToRow(at: index as IndexPath, at: .none, animated: true)
        //            }
        //        })
    }
    
    func loadMoreMessenger(){
        //        let lastIndex = listMessenger.first?.id
        //        print(listMessenger.first?.content as Any)
        //        print(lastIndex as Any)
        //        let nextPath = ref.child("messenger").child(self.pathMessage!).queryOrderedByKey().queryEnding(atValue: lastIndex!).queryLimited(toLast: 50)
        //
        //        nextPath.observeSingleEvent(of: FIRDataEventType.value, with:  { (dataSnapsoft) in
        //            print(dataSnapsoft)
        //            print(dataSnapsoft.children)
        //
        //            if let data = dataSnapsoft.value as? NSDictionary{
        //                var newMessenger = Messenger.parseListMessenger(data)
        //                for item in self.listMessenger{
        //                    newMessenger.append(item)
        //                }
        //                self.listMessenger = newMessenger
        //                self.tbMessage.reloadData()
        //
        //                if self.listMessenger.count != 0 {
        //                    let indexPath = IndexPath(row: 0, section: 0)
        //                    self.tbMessage.scrollToRow(at: indexPath, at: .top, animated: true)
        //                }
        //            }
        //        })
        
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
    
    @IBAction func btnBackClick(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
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
}
