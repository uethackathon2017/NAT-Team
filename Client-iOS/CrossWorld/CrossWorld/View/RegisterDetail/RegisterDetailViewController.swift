//
//  RegisterDetailViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import PopupController
import SwiftDate
import CountryPicker

class RegisterDetailViewController: AppViewController {

    // MARK: - Outlet
    
    // Button
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnBirthday: UIButton!
    
    // Form
    @IBOutlet weak var txtName: ASTextField!
    @IBOutlet weak var txtPass: ASTextField!
    @IBOutlet weak var txtRePass: ASTextField!
    @IBOutlet weak var txtCountry: ASTextField!
    @IBOutlet weak var txtBirthday: ASTextField!
    
    // MARK: - Declare
    
    var countryCode: String?
    
    // MARK: - Define
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = User.current
        if let name = user.fullName{
            txtName.text = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AppViewController
    override func setupViewController() {
        self.typeViewController = .child
        self.typeNavigationBar = .transparent
        self.rightButtonType = .none
        self.leftButtonType = .back
    }
    
    override func setupAction() {
        _ = self.btnNext.reactive.tap.observeNext { [weak self] in
            self?.btnNextTap()
        }
        
        _ = self.txtName.reactive.text.observeNext(with: { (text) in
            guard !(text?.isBlank)! else {
                return
            }
            User.current.fullName = text
        })
        
        _ = self.txtPass.reactive.text.observeNext(with: { (text) in
            User.current.password = text
        })
        
        _ = self.btnCountry.reactive.tap.observeNext { [weak self] in
            self?.showCountryPicker()
            self?.view.endEditing(true)
        }
        
        _ = self.btnBirthday.reactive.tap.observeNext { [weak self] in
            self?.showDatePicker()
        }
        
    }
    
    // MARK: - Action
    func validForm() -> AppError {
        let res = AppError()
        if (txtName.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankName
            return res
        }
        if (txtPass.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankPass
            return res
        } else if txtPass.text!.characters.count < 6 {
            res.isError = true
            res.errorType = .invalidPass
            return res
        }
        if (txtRePass.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankRePassword
            return res
        }
        if (txtCountry.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankCountry
            return res
        }
        if (txtBirthday.text ?? "").isBlank {
            res.isError = true
            res.errorType = .blankBỉthday
            return res
        }
        if txtPass.text != txtRePass.text {
            res.isError = true
            res.errorType = .invalidRePass
            return res
        }
        return res
    }
    
    func btnNextTap() {
        let valid = validForm()
        if !valid.isError {
            self.performSegue(withIdentifier: AppDefine.Segue.registerDetailToLanguage, sender: nil)
        }
    }
    
    func showCountryPicker() {
        let picker = CountryPickerViewController.initWithCode(code: countryCode ?? "")
        picker.pickerClosure = { [weak self] (code: String, flag: UIImage, country: String, name: String) in
            self?.txtCountry.text = name
            self?.txtCountry.animateViewsForTextEntry()
            self?.txtCountry.animateViewsForTextDisplay()
            User.current.countryId = country
        }
        picker.code = countryCode ?? "VN"
//        if !self.viewModel.countryCode.isBlank {
//            picker.phoneCode = self.viewModel.countryCode
//        }
        picker.popup = PopupController.create(self.navigationController ?? self).customize([
            PopupCustomOption.animation(PopupController.PopupAnimation.slideUp),
            PopupCustomOption.backgroundStyle(PopupController.PopupBackgroundStyle.blackFilter(alpha: 0.5)),
            PopupCustomOption.dismissWhenTaps(true),
            PopupCustomOption.movesAlongWithKeyboard(true),
            PopupCustomOption.layout(PopupController.PopupLayout.bottom)
            ]).show(picker)
    }
    
    func showDatePicker() {
        let pickerVC = DatePickerViewController()
        if let dateStr = self.txtBirthday.text {
            if let date = try? dateStr.date(format: DateFormat.custom("dd/MM/yyyy")).absoluteDate {
                pickerVC.dateSelect = date
            }
        }
        pickerVC.doneClosure = { [weak self] (date) in
            if let clearDate = date {
                self?.txtBirthday.text = clearDate.string(custom: "dd/MM/yyyy")
                self?.txtBirthday.animateViewsForTextEntry()
                self?.txtBirthday.animateViewsForTextDisplay()
                User.current.birthday = self?.txtBirthday.text
            }
        }
        pickerVC.popup = PopupController.create(self.tabBarController ?? self.navigationController ?? self).customize([
            PopupCustomOption.animation(PopupController.PopupAnimation.slideUp),
            PopupCustomOption.backgroundStyle(PopupController.PopupBackgroundStyle.blackFilter(alpha: 0.7)),
            PopupCustomOption.dismissWhenTaps(true),
            PopupCustomOption.movesAlongWithKeyboard(true),
            PopupCustomOption.layout(PopupController.PopupLayout.bottom),
            ]).show(pickerVC)
    }

}
