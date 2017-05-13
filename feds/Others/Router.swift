//
//  Router.swift
//  feds
//
//  Created by Alfred Thekkan on 5/6/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

class Router {
    var window: UIWindow!
    private static var _router = Router()
    init() {
        window = UIApplication.shared.delegate?.window ?? UIWindow(frame: UIScreen.main.bounds)
    }
    
    static var shared: Router {
        return _router
    }
    
    func setInitialViewController() {
        if User.isAuthorized {
            window.rootViewController = UIStoryboard.home.instantiateInitialViewController()
        }else {
            window.rootViewController = UIStoryboard.account.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
    }
    func setRootViewcontroller(_ vc: UIViewController) {
        window.rootViewController = vc
    }
}
