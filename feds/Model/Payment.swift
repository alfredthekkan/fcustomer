//
//  Payment.swift
//  feds
//
//  Created by Alfred Thekkan on 1/20/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import ObjectMapper

class Payment {
    var token: String?
    var type: PaymentType?
    
    required init(map:Map) {}
    init(type: PaymentType) {
        self.type = type
    }
    enum PaymentType:String {
        case cashOnDelivery = "cash"
        case creditCard = "credit"
    }
}

extension Payment: Mappable {
    func mapping(map:Map) {
        type <- map["paymenttype"]
        token <- map["gatewaytoken"]
    }
}
