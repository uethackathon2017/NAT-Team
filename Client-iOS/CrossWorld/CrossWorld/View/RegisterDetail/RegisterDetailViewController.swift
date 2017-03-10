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
            User.current.fullName = text
        })
        
        _ = self.txtPass.reactive.text.observeNext(with: { (text) in
            User.current.password = text
        })
        
        _ = self.btnCountry.reactive.tap.observeNext { [weak self] in
            self?.showCountryPicker()
        }
        
        _ = self.btnBirthday.reactive.tap.observeNext { [weak self] in
            self?.showDatePicker()
        }
        
    }
    
    // MARK: - Action
    func btnNextTap() {
        self.performSegue(withIdentifier: AppDefine.Segue.registerDetailToLanguage, sender: nil)
    }
    
    func showCountryPicker() {
        let picker = CountryPickerViewController.initWithCode(code: countryCode ?? "")
        picker.pickerClosure = { [weak self] (code: String, flag: UIImage, country: String, name: String) in
            self?.txtCountry.text = name
            self?.txtCountry.animateViewsForTextEntry()
            self?.txtCountry.animateViewsForTextDisplay()
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
