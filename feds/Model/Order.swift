//
//  Order.swift
//  Fedex
//
//  Created by TMC-4 on 7/11/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import Foundation

class Order {
    
    var fromAddress:DeliveryAddress!
    var toAddress:DeliveryAddress!
    
    var mobile = ""
    var orderDateTime = ""
    var orderPk = ""
    var orderTokenId = ""
    
    var price = ""
    var status = ""
    var statusName = ""
    var userName = ""
    
    var product_name = ""
    
    init(d:NSDictionary)  {
        
        if let x = d["mobile"] as? String {
            mobile = x
        }
        
        if let x = d["order_datetime"] as? String {
            orderDateTime = x
        }
        
        if let x = d["order_pk"] as? String {
            orderPk = x
        }
        
        if let x = d["order_tokenid"] as? String {
            orderTokenId = x
        }
        
        if let x = d["price"] as? NSNumber {
            price = "\(x.intValue)"
        }
        
        if let x = d["status"] as? String {
            status = x
        }
        
        if let x = d["status_name"] as? String {
            statusName = x
        }
        
        if let x = d["username"] as? String {
            userName = x
        }
        
        if let x = d["product_name"] as? String {
            product_name = x
        }
        
        if let addressArray = d["addresslist"] as? [NSDictionary] {
            for dict in addressArray {
                if let x = dict["type"] as? String {
                    if x == "to" {
                        fromAddress = DeliveryAddress(d: dict)
                    }else{
                        toAddress = DeliveryAddress(d: dict)
                    }
                }
            }
        }
        
        
        
    }
    
}
