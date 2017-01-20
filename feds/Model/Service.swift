//
//  Service.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

class Service {
    var image :UIImage!
    var type  :ServiceType = .invalid
    var name  :String!
    var maxWeight :Float!
    var size :Size!
    
    struct Size {
        var length  :Float
        var breadth :Float
        var height  :Float
    }
    
    
    
    class func createService(_ type: ServiceType) -> Service {
        let service = Service()
        service.type = type
        service.name = type.rawValue
        
        switch type {
        case .bike:
            service.image = UIImage(named: "bike_service")
            service.maxWeight = 30
            service.size = Size(length: 40, breadth: 40, height: 40)
        case .car:
            service.image = UIImage(named: "car_service")
            service.maxWeight = 200
            service.size = Size(length: 60, breadth: 60, height: 60)
        case .van:
            service.image = UIImage(named: "truck_service")
            service.maxWeight = 500
            service.size = Size(length: 250, breadth: 250, height: 250)
        default:
            print("Unknown service")
        }
        return service
    }
    public enum ServiceType: String {
        case bike    = "Bike"
        case car     = "Car"
        case van     = "Van"
        case invalid = "Invalid"
        
        var productId : Int{
            return [ServiceType.bike, ServiceType.car, ServiceType.van, ServiceType.invalid].index(of: self)!
        }
    }
}

extension Service :Equatable {
    static public func == (lhs :Service, rhs :Service) -> Bool {
        return lhs.type == rhs.type
    }
}
