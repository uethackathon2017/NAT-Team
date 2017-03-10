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
    
    
    // MARK: - Setup
    
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let index = self.segment.selectedSegmentIndex
            print(index)
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
        return 20
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
            cell.imgPhoto.image = #imageLiteral(resourceName: "TGUserInfo")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - TableViewAction
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: AppDefine.Segue.conversationToChat, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }


}
