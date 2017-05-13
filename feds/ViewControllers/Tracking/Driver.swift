//
//  Driver.swift
//  feds
//
//  Created by Alfred Thekkan on 5/13/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class Driver {
    var name    : String?
    var mobile  : String?
    var location: CLLocationCoordinate2D?
    var url     : String?
    fileprivate var _latitude: Double? {
        didSet {
            if _latitude != nil && _longitude != nil {
                location = CLLocationCoordinate2DMake(_latitude!, _longitude!)
            }
        }
    }
    fileprivate var _longitude: Double? {
        didSet {
            if _latitude != nil && _longitude != nil {
                location = CLLocationCoordinate2DMake(_latitude!, _longitude!)
            }
        }
    }
    required init?(map: Map) {
        mapping(map: map)
    }
    init() {}
}

extension Driver: Mappable {
    func mapping(map: Map) {
        mobile          <- map["driver_mobile"]
        _longitude      <- map["driver_ing"]
        _latitude       <- map["driver_lat"]
        name            <- map["driver_firstname"]
        url             <- map["driver_picture"]
    }
}
