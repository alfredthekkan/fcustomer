//
//  Password.swift
//  feds
//
//  Created by Alfred Thekkan on 5/12/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Password {
    
    var password: String
    init(_ password: String) {
        self.password = password
    }
    
    func update() -> Alamofire.DataRequest {
        let map = Map(mappingType: .toJSON, JSON: [:])
        User.current.accessToken <- map["accessToken"]
        self.password <- map["newpassword"]
        let URL = API.Url!.appendingPathComponent("changepassword")
        return SessionManager.default.request(URL, method: .post, parameters: map.JSON, encoding : JSONEncoding.default).validateErrors()
    }
}
