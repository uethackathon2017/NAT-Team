//
//  SpotyPeopleTableViewCell.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import IBAnimatable

class SpotyPeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var btnPeoples: [AnimatableButton]!
    @IBOutlet var lblPeoples: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
