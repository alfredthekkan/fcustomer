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
import Alamofire

class DeliveryAddress {
    
    var type:AddressType?
    var address:String?
    var floor:String?
    var building:String?
    var coordinate: CLLocationCoordinate2D!

    required init?(map: Map) {}
    init() { }
    
    class Distance{
        class GRow {
            var elements: [GElement]?
            required init?(map: Map) {mapping(map: map)}
            class GElement {
                class GDElement {
                    var text: String?
                    var value: Double?
                    required init?(map: Map) {}
                }
                var distance: GDElement?
                var duration: GDElement?
                required init?(map: Map) {}
            }
        }
        var rows: [GRow]?
        required init?(map: Map) {mapping(map: map)}
    }
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

//MARK: - API Calls
extension DeliveryAddress {
    func getDistance(fromAddress: DeliveryAddress, completionHandler: @escaping ((_ distance: Distance?, _ error: Error?) -> ())) {
        let source      = "\(fromAddress.coordinate.latitude),\(fromAddress.coordinate.longitude)"
        let destination = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let apiKey      = "AIzaSyDS_2FBWDUP259-moM4etKEfJFe0jpd4fY"
        let apiPath     = "https://maps.googleapis.com/maps/api/distancematrix/json"
        let urlString   = apiPath + "?origins=" + source + "&destinations=" + destination + "&key=" + apiKey
        let url         = URL(string: urlString)
        SessionManager.default.request(url!, method: .get, parameters: nil).validate().responseObject{ (response: DataResponse<Distance>) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            completionHandler(response.result.value, nil)
        }
    }
}

extension DeliveryAddress.Distance : Mappable {
    func mapping(map: Map) {
        rows <- map["rows"]
    }
}

extension DeliveryAddress.Distance.GRow: Mappable {
    func mapping(map: Map) {
        elements <- map["elements"]
    }
}

extension DeliveryAddress.Distance.GRow.GElement: Mappable {
    func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
    }
}

extension DeliveryAddress.Distance.GRow.GElement.GDElement: Mappable {
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}
