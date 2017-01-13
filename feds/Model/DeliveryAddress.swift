//
//  DeliveryAddress.swift
//  Fedex
//
//  Created by TMC-4 on 7/11/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class DeliveryAddress {
    
    var type:AddressType?
    var address:String?
    var floor:String?
    var building:String?
    var coordinate: CLLocationCoordinate2D!
    
    required init?(map: Map) {}
}

// MARK: - Enums
extension DeliveryAddress {
    enum AddressType: String {
        case destination = "to"
        case source = "from"
    }
}

//MARK: - Mappable conformance
extension DeliveryAddress: Mappable {
    func mapping(map: Map) {
        address                <- map["address"]
        building               <- map["address_building"]
        floor                  <- map["address_floor"]
        coordinate.latitude    <- map["address_ing"]
        coordinate.longitude   <- map["address_lat"]
        type                   <- map["type"]
    }
}
