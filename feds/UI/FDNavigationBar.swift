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

class FDNavigationController: UINavigationController {
    var previousBarTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FDNavigationController {
    override func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        previousBarTitle = navigationBar.topItem?.title
        navigationBar.topItem?.title = ""
        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        print(#function)
    }
    
    
    
}

protocol Cancellable {
    func cancelButton() -> UIBarButtonItem
}

extension Cancellable where Self: UIViewController {
    func cancelButton() -> UIBarButtonItem {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        cancelButton.action = #selector(Self.cancelTapped)
        return cancelButton
    }
}
extension UIViewController: Cancellable {
    internal func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

