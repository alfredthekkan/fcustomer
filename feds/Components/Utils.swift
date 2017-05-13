//
//  Utils.swift
//  feds
//
//  Created by Alfred Thekkan on 5/12/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation


extension NSObject {
    static var identifier: String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}

struct I18n {
    static func t(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension UIStoryboard {
    static var settings: UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var account: UIStoryboard {
        return UIStoryboard(name: "Account", bundle: nil)
    }
    static var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    static var tracking: UIStoryboard {
        return UIStoryboard(name: "Tracking", bundle: nil)
    }
    static var order: UIStoryboard {
        return UIStoryboard(name: "Order", bundle: nil)
    }
}
