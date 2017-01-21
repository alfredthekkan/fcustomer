//
//  ServiceTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

final class ServiceTableViewCell: Cell<Service>, CellType{

    @IBOutlet weak var typeLabel        :UILabel!
    @IBOutlet weak var specsLabel       :UILabel!
    @IBOutlet weak var serviceImageView :UIImageView!
    @IBOutlet weak var roundView        :UIView!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        roundView.layer.cornerRadius = 5.0
        roundView.layer.masksToBounds = true
        roundView.layer.backgroundColor = GlobalConstants.THEME_COLOR.cgColor
    }
    override func update() {
        super.update()
        guard let service = row.value else { return }
        typeLabel.text = service.name
        serviceImageView.image = service.image
        if isSelected{
            roundView.layer.backgroundColor = GlobalConstants.THEME_COLOR_GREY.cgColor
        }else{
            roundView.layer.backgroundColor = GlobalConstants.THEME_COLOR.cgColor
        }
    }
}

final class ServiceRow: Row<ServiceTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ServiceTableViewCell>(nibName: "ServiceTableViewCell")
    }
}
