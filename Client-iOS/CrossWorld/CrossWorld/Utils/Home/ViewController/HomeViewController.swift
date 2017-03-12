//
//  HomeViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Declare
    var viewModel = HomeViewModel()
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.newClient { [weak self] in
            self?.listenCallRequest()
        }
        viewModel.onGetNewMessage { [weak self] (mess) in
            if self?.tabBarController?.selectedIndex == 1{
                if let navi = self?.tabBarController?.viewControllers?[1] as? UINavigationController{
                    if let top = navi.viewControllers.last as? MessageViewController{
                        if top.room.room_id?.intValue == mess.room_id?.intValue {
                            return
                        }
                    }
                }
            }
            self?.viewModel.showAlert(mess: mess, tapHandle: {
                self?.tabBarController?.selectedIndex = 1
                if let navi = self?.tabBarController?.viewControllers?[1] as? UINavigationController{
                    if navi.viewControllers.count >= 2  {
                        navi.popToRootViewController(animated: true)
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AppViewController
    override func setupViewController() {
        self.typeViewController = .root
        self.typeNavigationBar = .normal
        self.rightButtonType = .notification
        self.leftButtonType = .user("")
        self.title = "Nhà"
        self.navigationItem.title = "CrossWorld"
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableviewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return viewModel.listCell.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 362
        } else {
            return 44
        }
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
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellHomeActivity, for: indexPath) as? HomeActivityTableViewCell {
                cell.btnFun.addTarget(self, action: #selector(goToLesson), for: .touchUpInside)
                cell.btnWord.addTarget(self, action: #selector(goToLesson), for: .touchUpInside)
                cell.btnLesson.addTarget(self, action: #selector(goToLesson), for: .touchUpInside)
                cell.btnActivity.addTarget(self, action: #selector(goToLesson), for: .touchUpInside)
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellHomeDetail, for: indexPath) as? HomeDetailTableViewCell {
                let model = viewModel.listCell[indexPath.row]
                cell.img.image = UIImage.init(named: model.image)
                cell.lblTitle.text = model.title
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - TableViewAction
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.tabBarController?.selectedIndex = 1
            } else if indexPath.row == 1 {
                Utils.showAlertDefault("Thông báo", message: "Bạn chưa hoàn thành bài tập nào", buttons: ["Ok"], completed: nil)
            } else if indexPath.row == 2 {
                self.tabBarController?.selectedIndex = 2
            } else if indexPath.row == 3 {
                Utils.showAlertDefault("Thông báo", message: "Kết quả của bạn sẽ được cập nhật sớm nhất", buttons: ["Ok"], completed: nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }
}

// MARK: - Action
extension HomeViewController {
    func goToLesson() {
        self.performSegue(withIdentifier: AppDefine.Segue.homeToLesson, sender: nil)
    }
}
