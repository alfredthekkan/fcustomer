//
//  Session.swift
//  feds
//
//  Created by Alfred Thekkan on 3/7/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class Session {
    static func delete() {
        User.current.accessToken = nil
        User.isAuthorized = false
    }
}
