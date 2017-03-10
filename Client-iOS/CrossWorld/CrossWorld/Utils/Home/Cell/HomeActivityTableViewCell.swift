//
//  HomeActivityTableViewCell.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class HomeActivityTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var btnLesson: UIButton!
    @IBOutlet weak var btnWord: UIButton!
    @IBOutlet weak var btnFun: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
