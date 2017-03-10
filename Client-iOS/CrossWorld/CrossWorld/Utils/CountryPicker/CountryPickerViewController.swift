//
//  CountryPickerViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 2/16/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import PopupController
import CountryPicker

class CountryPickerViewController: UIViewController, PopupContentViewController, CountryPickerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var countryPicker: CountryPicker!
    
    // MARK: - Delcare
    var popup = PopupController()
    var pickerClosure: ((_ code: String, _ flag: UIImage, _ country: String, _ name: String)->Void)?
    var code: String = ""
    var name: String = ""
    var flag: UIImage = UIImage()
    var phoneCode: String = ""
    
    // MARK: - ViewController
    class func initWithCode(code: String) -> CountryPickerViewController {
        let res = CountryPickerViewController.init(nibName: "CountryPickerViewController", bundle: nil)
        return res
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.countryPicker.countryPickerDelegate = self
        if !code.isBlank {
            countryPicker.setCountry(code)
        }
//        if !phoneCode.isBlank {
//            countryPicker.setCountryByPhoneCode(phoneCode)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Popup
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize.init(width: AppDefine.Define.sizeOfScreen.width, height: 285)
    }
    
    // MARK: - CountryPicker
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.phoneCode = phoneCode
        self.name = name
        self.flag = flag
        self.code = countryCode
    }
    
    // MARK: - Action
    
    @IBAction func picker(_ sender: Any) {
        pickerClosure?(self.phoneCode, self.flag, self.code, self.name)
        self.popup.dismiss()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.popup.dismiss()
    }

}
