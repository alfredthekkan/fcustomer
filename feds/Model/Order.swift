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
    var service         :ServiceType = .invaid
    
    required init?(map: Map) {}
}

public enum ServiceType: String {
    case bike   = "Bike"
    case car    = "Car"
    case van    = "Van"
    case invaid = "Invalid"
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
