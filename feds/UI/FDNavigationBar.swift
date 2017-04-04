//
//  FDNavigationBar.swift
//  feds
//
//  Created by Alfred Thekkan on 3/11/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit

class FDNavigationBar: UINavigationBar {
    override func draw(_ rect: CGRect) {
         super.draw(rect)
        tintColor = GlobalConstants.THEME_COLOR
        
    }
}

extension UIViewController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        navigationBar.topItem?.title = ""
        return true
    }
}
