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
    
    var order: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _customizeView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Populate date into cell
    func setupOrder(_ order: Order) {
        if let price = order.price {
            lblPrice.text = "PRICE - \(price) AED"
        }
        if let source = order.fromAddress?.address, let destination = order.toAddress?.address {
            lblLocationName.text = "DELIVERY - \(source) - \(destination)"
        }
        if let status = order.orderStatus {
            switch status {
                case .pending:
                    backgroundColor = .brown
                case .assigned:
                    backgroundColor = .orange
                case .ongoing:
                    backgroundColor = .green
            }
        }
        let im = accessoryView as! UIImageView
        im.image = order.service.image
    }
    
    //MARK: - Private Methods
    private func _customizeView() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let iv = UIImageView(frame: frame)
        iv.contentMode = .scaleAspectFit
        accessoryView = iv
        backgroundColor = GlobalConstants.THEME_COLOR
        let bv = UIView(frame: frame)
        bv.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        selectedBackgroundView = bv
    }
}
