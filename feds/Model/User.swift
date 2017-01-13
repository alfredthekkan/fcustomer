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
    
    func update(with params:Parameters){
        let map = Map(mappingType: .fromJSON, JSON: params)
        mapping(map: map)
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
    
    static func create(_ parameters:Parameters) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("register")
        return SessionManager.default.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
            if let _ = response.result.error { return }
            let value = response.result.value as! Parameters
            let data  = value["data"] as! Parameters
            let user = User(JSON: parameters)
            User.current = user
            User.current.update(with: data)
        })
    }
    
    func logout() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("logout")
        let params = ["accesToken":accessToken!]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default)
    }
}
