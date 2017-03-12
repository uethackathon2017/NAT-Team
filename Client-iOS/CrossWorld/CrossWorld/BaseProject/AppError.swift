//
//  AppError.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class AppError {
    var isError: Bool = false
    var errorType: ErrorType = .none
    
    enum ErrorType: String {
        case none = ""
        // User
        case blankUserName = "Hãy nhập tên tài khoản"
        case blankPass = "Hãy nhập mật khẩu"
        case blankRePassword = "Hãy nhập lại mật khẩu"
        case blankMobile = "Hãy nhập số điện thoại"
        case blankCountry = "Chọn đất nước của bạn"
        case blankBỉthday = "Bạn chưa chọn ngày sinh"
        case blankName = "Bạn chưa nhập tên"
        
        case invalidPass = "Mật khẩu không hợp lệ"
        case invalidRePass = "Mật khẩu không khớp"
    }
}
