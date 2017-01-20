//
//  LocationTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 1/20/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Eureka

class LocationTableViewCell: Cell<String>, CellType {
    
    @IBOutlet weak var nameLabel       :UILabel!
    @IBOutlet weak var locationImageView :UIImageView!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update() {
        super.update()
        let row = self.row as? LocationTitleRow
        guard let location = row?.value else { return }
        nameLabel.text = location
        if row?.type == .destination {
            locationImageView.image = UIImage(named: "deliverTo")
        }else{
            locationImageView.image = UIImage(named: "pickFromHere")
        }
    }
}
final class LocationTitleRow: Row<LocationTableViewCell>, RowType {
    var type: LocationType = .source
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<LocationTableViewCell>(nibName: "LocationTableViewCell")
    }
}

public enum LocationType: String {
    case source = "from"
    case destination = "to"
}
