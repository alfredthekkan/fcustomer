//
//  Order.swift
//  Fedex
//
//  Created by TMC-4 on 7/11/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class Order {
    var fromAddress     :DeliveryAddress!
    var toAddress       :DeliveryAddress!
    var mobile          :String?
    var orderDateTime   :String?
    var orderPk         :String?
    var orderTokenId    :String?
    var price           :String?
    var status          :String?
    var statusName      :String?
    var userName        :String?
    var service         :ServiceType = .invalid
    
    required init?(map: Map) {}
}

public enum ServiceType: String {
    case bike    = "Bike"
    case car     = "Car"
    case van     = "Van"
    case invalid = "Invalid"
}

extension Order: Mappable {
    func mapping(map: Map) {
        mobile          <- map["mobile"]
        orderDateTime   <- map["order_datetime"]
        orderPk         <- map["order_pk"]
        orderTokenId    <- map["order_tokenid"]
        price           <- map["price"]
        status          <- map["status"]
        statusName      <- map["status_name"]
        userName        <- map["username"]
        service         <- map["product_name"]
    }
}

//MARK: - API Calls
extension Order {
    static func fetch(completionHandler : @escaping ([Order]?, Error?) -> Void) {
        let URL = API.Url!.appendingPathComponent("getorders")
        let params = ["accessToken":User.current.accessToken!]
        SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validate().responseArray(keyPath: "data") {(response : DataResponse<[Order]>) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            completionHandler(response.result.value!, nil)
        }
    }
    func create(){
        
    }
}
