//
//  User.swift
//  feds
//
//  Created by Alfred Thekkan on 1/13/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class User {
    
    static var current     :User!
    
    var firstName   :String?
    var lastName    :String?
    var email       :String?
    var mobile      :String?
    var password    :String?
    var accessToken :String?
    
    required init?(map: Map) {}
}

extension User: Mappable {
    func mapping(map: Map) {
        firstName       <- map["fullname"]
        email           <- map["email"]
        mobile          <- map["mobile"]
        accessToken     <- map["accessToken"]
    }
}

//MARK: - API Calls
extension User {
    static func login(_ username: String, _ password: String) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("authenticate")
        let params = ["username":username, "password":password]
        
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validate().responseObject(keyPath: "data") {(response : DataResponse<User>) in
            User.current = response.result.value}
    }
    
    func logout() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("logout")
        let params = ["accesToken":accessToken!]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default)
    }
}
