//
//  RightChatCell.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class RightChatCell: UITableViewCell {

    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbSenderMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.clipsToBounds = true
    }
    
    func showMessageTime(){
        lbTime.isHidden = !lbTime.isHidden
    }

}
