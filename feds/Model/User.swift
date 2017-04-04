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
    
    private static var _current: User!
    static var current     :User! {
        get {
            return _current != nil ? _current : User()
        }set {
            _current = newValue
        }
    }
    static var isAuthorized: Bool{
        set{
            UserDefaults.standard.set(newValue, forKey:  GlobalConstants.kIsAuthorized)
        }get{
            return UserDefaults.standard.bool(forKey:GlobalConstants.kIsAuthorized) != false
        }
    }
    var firstName   :String?
    var lastName    :String?
    var email       :String?
    var mobile      :String?
    var password    :String?
    var accessToken :String? {
        didSet {
            if accessToken != nil {
                UserDefaults.standard.set(accessToken, forKey: GlobalConstants.KEY_ACCESS_TOKEN)
            }else{
                UserDefaults.standard.removeObject(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
            }
        }
    }
    
    init() {
        let accessToken = UserDefaults.standard.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
        self.accessToken = accessToken
    }
    
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
    static func login(_ username: String, _ password: String, _ isFbLogin:Bool = false) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("authenticate")
        
        var params: [String: String]!
        if isFbLogin {
            params = ["facebook_id":username]
        }else {
            params = ["username":username, "password":password]
        }
        
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validateErrors().responseObject(keyPath: "data") {(response : DataResponse<User>) in
            User.current = response.result.value}
    }
    
    static func forgotPassword(_ input: [String: Any]) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("forgotpassword")
        return SessionManager.default.request(URL, method: .post, parameters: input, encoding: JSONEncoding.default).validateErrors()
        
    }
    
    static func fbLogin(_ token: String, _ email: String) -> Alamofire.DataRequest {
        
        let URL = API.Url!.appendingPathComponent("facebooklogin")
        
        var params: [String: String]!
        params = ["facebook_id":token, "username": email]
        
        
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validateErrors().responseObject(keyPath: "data") {(response : DataResponse<User>) in
            User.current = response.result.value}
    }
    
    static func create(_ parameters:Parameters) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("register")
        return SessionManager.default.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validateErrors().responseJSON(completionHandler: {response in
            if let _ = response.result.error { return }
            let map = Map(mappingType: .fromJSON, JSON: response.result.value as! [String : Any])
            User.current <- map["data"]
            User.isAuthorized = true
        })
    }
    
    func logout() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("logout")
        let params = ["accesToken":accessToken!]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default)
    }
}

extension Alamofire.DataRequest{
    func validateErrors() -> Self {
        return validate{ _, response, data in
            
            if response.statusCode == 200 {
                return .success
            }else{
                var msg:String? = ""
                if let data = data {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        let errorDict = dict?["data"] as? [String: String]
                        msg = errorDict?["error"]
                    }catch{
                        msg = "Response is empty"
                    }
                }
                if msg == nil {
                    msg = "Response is empty"
                }
                let error = NSError(domain: msg!, code: response.statusCode, userInfo: nil)
                return .failure(error)
            }
        }.debugLog()
    }
    
    private func debugLog() -> Self {
        debugPrint(self)
        return self
    }
    
}
