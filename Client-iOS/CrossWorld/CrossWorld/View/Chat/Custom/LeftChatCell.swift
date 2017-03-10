//
//  LeftChatCell.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class LeftChatCell: UITableViewCell {

    @IBOutlet weak var constrainLbTimeWidth: NSLayoutConstraint!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbReceiveMsg: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.clipsToBounds = true
        self.lbTime.isHidden = true
    }
    
    func showMessageTime(){
        lbTime.isHidden = !lbTime.isHidden
    }

}
