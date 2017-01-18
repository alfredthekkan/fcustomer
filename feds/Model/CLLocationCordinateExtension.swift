//
//  CLLocationCordinateExtension.swift
//  feds
//
//  Created by Alfred Thekkan on 1/18/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

extension CLLocationCoordinate2D {
    
    var stringValue:String { return "\(latitude),\(longitude)" }
    func getPlaceName(completion: @escaping ((String?, Error?) -> ())) {
        let apiKey      = "AIzaSyAODUPrf6e6M9xflCqDUZdrW7RrWRx2Po0"
        let apiPath     = "https://maps.googleapis.com/maps/api/geocode/json"
        let urlString   = apiPath + "?latlng=" + stringValue + "&key=" + apiKey
        let url         = URL(string: urlString)
        SessionManager.default.request(url!, method: .get, parameters: nil).validate().responseObject{
            (response: DataResponse<Place>) in
            if let error = response.result.error {
                completion(nil, error)
            }
            completion(response.result.value?.results?.first?.formattedAdderss, nil)
        }
    }
}

class Place {
    var results : [GResult]?
    required init?(map: Map) {}
    class GResult {
        var formattedAdderss    : String?
        var types               : [Level]?
        required init?(map: Map) {}
    }
}

extension Place {
    enum Level:String {
        case route = "route"
        case admininstrativeAreaLeve2 = "administrative_area_level_2"
        case political = "political"
        case admininstrativeAreaLeve1 = "administrative_area_level_1"
        case country = "country"
    }
}

extension Place : Mappable {
    func mapping(map: Map) {
        results <- map["results"]
    }
}

extension Place.GResult : Mappable {
    func mapping(map: Map) {
        formattedAdderss    <- map["formatted_address"]
        types               <- map["types"]
    }
}

