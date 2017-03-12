//
//  UserViewController.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class UserViewController: AppViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Outlet
    
    @IBOutlet weak var tbUser: UITableView!
    
    // MARK: - Declare
    
    
    // MARK: - Define
    let viewModel = UserModel()
    var imagePicker = UIImagePickerController()
    
    // MARK: - Setup
    
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViewController() {
        leftButtonType = .cancel
        typeNavigationBar = .transparent
        typeViewController = .present
    }
    
    // MARK: - TableviewDelegate
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tbDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tbDataSource[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.getCellData(index: indexPath).height)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.tbDataSource[section].footerHeihgt)
    }
    
    // MARK: - TableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell", for: indexPath) as? AvatarTableViewCell{
                
                cell.btnAvatar.addTarget(self, action: #selector(showActionSheetPickImage), for: .touchUpInside)
                if let avatar = User.current.avatar{
                    cell.btnAvatar.kf.setImage(with: URL(string: avatar), for: .normal)
                    cell.btnAvatar.imageView?.contentMode = .scaleAspectFill
                }
                
                return cell
            }
        }
        if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutTableViewCell", for: indexPath) as? LogoutTableViewCell{
                return cell
            }
        }
        
        let item = viewModel.getCellData(index: indexPath)
        if indexPath.section == 0 || indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailTableViewCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.textLeft
            
            return cell
            
        }
        
        if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleTableViewCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.des
            return cell
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailTableViewCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.des
            if let image = item.image {
                cell.imageView?.image = UIImage(named: image)
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
        if indexPath.section == viewModel.tbDataSource.count - 1{
            
            DataAccess.shared.removeUser()
            
            //            APIRequest().logout(handle: { (isSuccess, data) in
            //                //
            //            })
            if let view = self.presentingViewController as? UITabBarController{
                self.dismiss(animated: true, completion: nil)
                view.dismiss(animated: true, completion: nil)
            }
         
            return
        }
        
        if indexPath.section == 4 {
            //self.performSegue(withIdentifier: Define.segue.userToChangepass, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UIPicker Image
    func showActionSheetPickImage(){
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take a photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
            self.openLibrary()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            //
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func openLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            if let cell = tbUser.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? AvatarTableViewCell{
                cell.btnAvatar.setImage(image, for: .normal)
                cell.btnAvatar.imageView?.contentMode = .scaleAspectFill
            }
        }
        
        picker.dismiss(animated: true) {
            
        }
    }
    
}
