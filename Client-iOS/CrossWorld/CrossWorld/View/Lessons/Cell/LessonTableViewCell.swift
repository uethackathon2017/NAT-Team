//
//  LessonTableViewCell.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import IBAnimatable

class LessonTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgAuthor: UIImageView!
    @IBOutlet weak var btnUnLock: AnimatableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
