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
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        selectedBackgroundView = cellBackgroundView
        backgroundColor = GlobalConstants.THEME_COLOR
    }
    override func update() {
        super.update()
        guard let service = row.value else { return }
        typeLabel.text = service.name
        specsLabel.text = "MAXIMUM SIZE: " + "\(service.size.length) CM X \(service.size.breadth) CM X \(service.size.height) CM\nMAXIMUM WEIGHT:\(service.maxWeight!) KG"
        serviceImageView.image = service.image
    }
}

final class ServiceRow: Row<ServiceTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ServiceTableViewCell>(nibName: "ServiceTableViewCell")
    }
}
