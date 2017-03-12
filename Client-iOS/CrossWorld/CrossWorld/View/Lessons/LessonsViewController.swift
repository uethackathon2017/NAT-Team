//
//  LessonsViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import SwiftMessages

class LessonsViewController: AppViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Declare
    var viewModel = LessonViewModel()
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AppViewController
    override func setupViewController() {
        self.typeViewController = .child
        self.typeNavigationBar = .normal
        self.leftButtonType = .back
        self.title = "Bài học"
    }

}

extension LessonsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableviewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 332
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellLesson, for: indexPath) as? LessonTableViewCell {
            let model = viewModel.listCell[indexPath.row]
            cell.lblTitle.text = model.title
            cell.lblName.text = model.nameLesson
            cell.lblAuthor.text = model.author
            cell.imgCover.image = UIImage(named: model.imageUrl)
            cell.lblDes.text = model.shortDes
            if model.isUnLock {
                cell.btnUnLock.isHidden = true
            }else{
                cell.btnUnLock.isHidden = false
                cell.btnUnLock.addTarget(self, action: #selector(unlockCource), for: .touchUpInside)
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
        //
        let item = viewModel.listCell[indexPath.row]
        if item.isUnLock {
            self.performSegue(withIdentifier: AppDefine.Segue.lessonToPlayVideo, sender: nil)

        }else{
            unlockCource()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }
    
    func unlockCource(){
        showAlert(mess: "Bạn cần 99 điểm để mở khoá bài học")
    }
    func showAlert( mess: String){
        let view = MessageView.viewFromNib(layout: .CardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning)
        
        view.configureContent(title: "Warning", body: mess, iconText: "🤔")
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        view.button?.isHidden = true
    
        // Show the message.
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: config, view: view)
    }

}
