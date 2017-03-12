//
//  LeftImageTableViewCell.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class LeftImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbReceiveMsg: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
