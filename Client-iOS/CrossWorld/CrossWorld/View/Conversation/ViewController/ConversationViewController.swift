//
//  ConversationViewController.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class ConversationViewController: AppViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlet
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tbConverstation: UITableView!
    
    
    // MARK: - Declare
    
    
    // MARK: - Define
    let viewModel = ConverstaionViewModel()
    
    // MARK: - Setup
    
    func getData(){
        BannerManager.share.showWaiting(withContent: "Loading", isStatusLevel: false, inViewController: self)
        viewModel.getData { (isSuccess) in
            BannerManager.share.hideWaiting()
            if isSuccess{
                self.tbConverstation.reloadData()
            }
        }
    }
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reloadData()
    }
    
    override func setupViewController() {
        super.setupViewController()
        
        leftButtonType = .user("")
        rightButtonType = .notification
        typeNavigationBar = .normal
        self.title = AppDefine.Screen.converstation
    }
    
    override func setupAction() {
        super.setupAction()
        
        _ = segment.reactive.controlEvents(.valueChanged).observeNext {
            self.tbConverstation.reloadData()
        }
    }

    // MARK: - TableviewDelegate
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "            ") {action in
            //handle delete
        }
        
        deleteAction.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "delete"))
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.room != nil else {
            return 0
        }
        
        switch segment.selectedSegmentIndex {
            
        case 0:
            return viewModel.room?.friend_room.count ?? 0
        case 1:
            
            return viewModel.room?.native_room.count ?? 0
            
        case 2:
            return viewModel.room?.foreign_room.count ?? 0
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - TableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as? ConversationTableViewCell {
            if let item = getRoomDetail(index: indexPath.row){
                if let avt = item.avatar{
                    cell.imgPhoto.kf.setImage(with: URL(string: avt))
                }
                
                cell.lbName.text = item.full_name
                cell.lbLastMess.text = item.message
                cell.lbTime.text = item.time?.getHourAndMinute()
                
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - TableViewAction
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: AppDefine.Segue.conversationToChat, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }

    func getRoomDetail(index: Int) -> RoomDetail?{
        guard viewModel.room != nil else {
            return nil
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            
            return (viewModel.room?.friend_room[index])
            
        case 1:
            return (viewModel.room?.native_room[index])
            
        case 2:
            return (viewModel.room?.foreign_room[index])
            
        default:
            return nil
            
        }

    }

}
extension ConversationViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppDefine.Segue.conversationToChat{
            if let des = segue.destination as? MessageViewController{
                if let index = sender as? Int {
                    if let room = getRoomDetail(index: index) {
                        des.room = room
                    }
                }
            }
        }
    }
}
