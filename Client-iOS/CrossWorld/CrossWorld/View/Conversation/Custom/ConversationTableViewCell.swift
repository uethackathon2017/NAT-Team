//
//  ConversationTableViewCell.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    // MARK: - Outlet
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbMessUnreadCount: UILabel!
    @IBOutlet weak var lbLastMess: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    // MARK: - Declare
    
    
    // MARK: - Define
    
    
    // MARK: - Setup
    
    
    // MARK: - Lifecircle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
