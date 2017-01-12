//
//  CourierTableViewCell.swift
//  Fedex
//
//  Created by TMC-4 on 6/29/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

class CourierTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLocationName:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
