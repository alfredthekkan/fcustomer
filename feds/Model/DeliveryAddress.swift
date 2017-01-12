//
//  DeliveryAddress.swift
//  Fedex
//
//  Created by TMC-4 on 7/11/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import Foundation

class DeliveryAddress {
    
    
    var type = "to"
    var address = "empty address"
    var address_lat = "23.32"
    var addres_ing = "34.43"
    var addres_floor = ""
    var address_building = ""
    
    init(d:NSDictionary){
        
        if let x = d["type"] as? String {
            type = x
        }
        
        if let x = d["address"] as? String {
            address = x
        }
        
        if let x = d["address_building"] as? String {
            address_building = x
        }
        
        if let x = d["address_floor"] as? String {
            addres_floor = x
        }
        
        if let x = d["address_ing"] as? String {
            addres_ing = x
        }
        
        if let x = d["address_lat"] as? String {
            address_lat = x
        }
        
        
        
    }
}