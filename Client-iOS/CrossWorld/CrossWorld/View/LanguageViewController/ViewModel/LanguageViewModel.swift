//
//  LanguageViewModel.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class LanguageViewModel {
    
    struct CellDescription {
        var name: String = ""
        var image: String = ""
        var id: Int = -1
    }
    
    var listCell: [CellDescription] = [
        CellDescription(name: "English", image: "language_English", id: 0),
        CellDescription(name: "Vietnamese", image: "language_vn", id: 1),
        CellDescription(name: "Japanese", image: "language_jp", id: 2),
        CellDescription(name: "Chinese", image: "language_English", id: 3),
        CellDescription(name: "Spanise", image: "language_vn", id: 4)
    ]
    
    func register(complite: @escaping (_ isComplite: Bool)->Void){
        APIRequest().registerAPI { (isSuccess, data) in
            if isSuccess {
                complite(true)
            }else{
                complite(false)
            }
        }
    }
    
}
