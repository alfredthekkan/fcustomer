//
//  API.swift
//  feds
//
//  Created by Alfred Thekkan on 1/13/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

class API {
    static var baseURL = "http://test.feds4u.ae"
    static var prefix  = "/api/"
    static var Url     = URL(string:baseURL.appending(prefix))
}
