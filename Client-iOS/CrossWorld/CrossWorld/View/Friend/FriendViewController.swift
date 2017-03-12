//
//  FriendViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import Kingfisher

class FriendViewController: AppViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Declare
    var viewModel = FriendViewModel()
    
    var listRandomUser: [User] = [] {
        didSet {
            if listRandomUser.count > 0 {
                let des = FriendViewModel.SpotyCellDescription(title: "Ngẫu nhiên", users: listRandomUser)
                self.viewModel.listSpotyCell = [des]
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        self.title = "Mọi người"
    }
    
    override func setupUI() {
        viewModel.getListRandom { [weak self] (listUser) in
            self?.listRandomUser = listUser
        }
    }

}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableviewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.listSpotyCell.count
        case 1:
            return viewModel.listAction.count
        case 2:
            return viewModel.listPeople.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 54
        case 2:
            return 54
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            return "Tất cả bạn bè"
        default:
            return nil
        }
    }
    
    // MARK: - TableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellSpotyPeople, for: indexPath) as? SpotyPeopleTableViewCell {
                let model = viewModel.listSpotyCell[indexPath.row]
                cell.lblTitle.text = model.title
                cell.listUser = model.users
                for index in 0...(model.users.count - 1) {
                    cell.btnPeoples[index].tag = index
                    cell.btnPeoples[index].addTarget(self, action: #selector(createRoom), for: .touchUpInside)
                    cell.lblPeoples[index].text = model.users[index].fullName
                    cell.lblPeoples[index].isHidden = false
                    (cell.btnPeoples[index] as UIButton).kf.setBackgroundImage(with: URL(string: model.users[index].avatar ?? ""), for: .normal)
                    cell.btnPeoples[index].isHidden = false
                }
                return cell
            }
            break
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellActionFriend, for: indexPath)
            let model = viewModel.listAction[indexPath.row]
            cell.textLabel?.text = model
            return cell
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AppDefine.cellId.idCellPeople, for: indexPath) as? PeopleTableViewCell {
                let model = viewModel.listPeople[indexPath.row]
                cell.lblName.text = model.title
                cell.imgAvatar.image = UIImage().randomAvatar()
                //cell.imgAvatar.kf.setImage(with: URL.init(string: model.urlAvatar))
//                cell.btnCall.addTarget(self, action: #selector(showCall), for: .touchUpInside)
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - TableViewAction
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //
    }
}

extension FriendViewController {
//    func makeVideoCall() {
//        self.showCall()
//    }
    
    func createRoom(_ sender: UIButton) {
        let other = listRandomUser[sender.tag]
        let param = [
            "user_id": User.current.user_id ?? "",
            "other_user": other.user_id ?? ""
        ]
        let ack = SocketRequest.share.appSocket.emitWithAck("create-room", param)
        ack.timingOut(after: 20) { [weak self] (data) in
            if let selfStrong = self {
                if let data = data.first as? NSDictionary{
                    let res = ResObject(dictionary: data)
                    if let data = res.data{
                        if let roomId = data.value(forKey: "room_id") as? NSNumber {
                            if let mesVC = self?.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
                                let room = RoomDetail()
                                room.avatar = other.avatar
                                room.full_name = other.fullName
                                room.room_id = roomId
                                mesVC.room = room
                                self?.navigationController?.pushViewController(mesVC, animated: true)
                            }
                        }
                    }else{
                        
                    }
                }else{
                    
                }
            }
        }
    }
    
}


