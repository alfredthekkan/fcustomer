//
//  BackView.swift
//  feds
//
//  Created by Alfred Thekkan on 3/11/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

@IBDesignable
class BackView: UIView {
    override func draw(_ rect: CGRect) {
        let image = #imageLiteral(resourceName: "pattern")
        let imageLayer = CALayer()
        imageLayer.contentsGravity = kCAGravityResizeAspectFill
        imageLayer.frame = bounds
        imageLayer.contents = image.cgImage
        imageLayer.opacity = 0.4
        layer.insertSublayer(imageLayer, at: 0)
        clipsToBounds = true
    }
}
