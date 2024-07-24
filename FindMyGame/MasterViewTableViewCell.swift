//
//  MasterViewTableViewCell.swift
//  FindMyGame
//
//  Created by Bhuvana on 27/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import UIKit

class MasterViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var userTypeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
