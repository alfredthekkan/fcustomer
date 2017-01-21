//
//  Paymentbutton.swift
//  feds
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
@IBDesignable
class Paymentbutton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        layer.cornerRadius = 5.0
        layer.backgroundColor = GlobalConstants.THEME_COLOR.cgColor
        layer.masksToBounds = true
    }
    

}
