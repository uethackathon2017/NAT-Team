//
//  DatePickerViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import PopupController

class DatePickerViewController: UIViewController, PopupContentViewController {
    
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var popup = PopupController()
    var dateSelect: Date?
    var doneClosure: ((Date?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let date = dateSelect {
            self.picker.setDate(date, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelTap(_ sender: UIButton) {
        self.popup.dismiss()
    }
    
    @IBAction func btnDoneTap(_ sender: UIButton) {
        self.popup.dismiss { [weak self] in
            self?.doneClosure?(self?.picker.date)
        }
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let size = CGSize.init(width: AppDefine.Define.sizeOfScreen.width, height: 267)
        return size
    }
    
}
