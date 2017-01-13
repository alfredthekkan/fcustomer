//
//  MenuItem.swift
//  feds
//
//  Created by Alfred Thekkan on 1/13/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Alamofire

class MenuItem {
    var imageName               :String?
    var hightlightedImageName   :String?
    var type                    :MenuType = .supermarket
    
    enum MenuType : String {
        case supermarket    = "Supermarket Services"
        case pr             = "Pr Services"
        case trackOrder     = "Track Order"
        case newOrder       = "New Order"
        case pharmacy       = "Pharmacy"
        case contact        = "Contact"
    }
    
    init(imageName: String, hightlightedImageName: String, type :MenuType) {
        self.imageName              = imageName
        self.hightlightedImageName  = hightlightedImageName
        self.type                   = type
    }
    
    static func allitems() -> [MenuItem] {
        let m1 = MenuItem(imageName: "courier", hightlightedImageName: "courier_selected", type: .newOrder)
        let m2 = MenuItem(imageName: "contactusunselected", hightlightedImageName: "contactusselected", type: .contact)
        let m3 = RequestItem(imageName: "pharmacy", hightlightedImageName: "pharmacy_selected", type: .pharmacy)
        let m4 = RequestItem(imageName: "pr", hightlightedImageName: "pr_selected", type: .pr)
        let m5 = RequestItem(imageName: "supermarket", hightlightedImageName:  "supermarket_selected", type: .supermarket)
        let m6 = MenuItem(imageName: "trackorder", hightlightedImageName: "trackorder_selected", type: .trackOrder)
        return [m1, m2, m3, m4, m5, m6]
    }
}

protocol ServiceRequestable {
    func request() -> Alamofire.DataRequest
}

class RequestItem : MenuItem {}

extension RequestItem : ServiceRequestable {
    func request() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("requestcall")
        let params = ["accessToken":User.current.accessToken!, "servicename":type.rawValue]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validate()
    }
}
