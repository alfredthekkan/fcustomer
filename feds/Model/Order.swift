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
import PromiseKit
import CoreLocation

final class Order {
    
    static var _current :Order?
    static var current  :Order?{
        get {
            if _current == nil {
                _current = Order()
            }
            return _current!
        }
        set{
            _current = newValue
        }
    }
    fileprivate var _addresses:[DeliveryAddress] = [DeliveryAddress(type: .source)]
    var fromAddress     :DeliveryAddress?{
        get{
            return _addresses.first
        }set{
            _addresses[0] = newValue!
        }
    }
    
    var toAddress     :DeliveryAddress?{
        get{
            return _addresses.count > 1 ? _addresses.last : nil
        }set{
            if _addresses.count > 1 {
                _addresses[1] = newValue!
            }else{
                _addresses.append(newValue!)
            }
        }
    }
    var mobile          :String?
    var orderDateTime   :String?
    var orderPk         :Double?
    var orderTokenId    :String?
    var price           :Double?
    var status          :String?
    var statusName      :String?
    var userName        :String?
    var service         :Service.ServiceType = .invalid
    var payment         :Payment?
    var distance        :Double! = 0
    var driver          :Driver?
    var orderStatus     :OrderStatus?
    
    required init?(map: Map) {}
    init() {}
    
    enum OrderStatus: String {
        case pending = "pending"
        case assigned = "assigned"
        case ongoing = "ongoing"
    }
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
        distance        <- map["distance"]
        _addresses      <- map["addresslist"]
        driver = Driver(map: map)
        orderStatus <- map["status_name"]
    }
}

//MARK: - API Calls
extension Order {
    static func fetch(completionHandler : @escaping ([Order]?, Error?) -> Void) {
        let URL = API.Url!.appendingPathComponent("getorders")
        let params = ["accessToken":User.current.accessToken!]
        SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validateErrors().responseArray(keyPath: "data") {(response : DataResponse<[Order]>) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            completionHandler(response.result.value!, nil)
        }
    }
    
    func update() -> Promise<CLLocationCoordinate2D> {
        let (promise, fulfill, reject) = Promise<CLLocationCoordinate2D>.pending()
        
        let URL = API.Url!.appendingPathComponent("getorders")
        let params: [String: Any] = ["accessToken":User.current.accessToken!, "order_pk": orderPk!]
        SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validateErrors().responseArray(keyPath: "data") {(response : DataResponse<[Order]>) in
            if let error = response.result.error {
                reject(error)
                return
            }
            if let location = response.result.value?.first?.driver?.location {
                fulfill(location)
            }else {
                reject(NSError(domain: "NSErrorDomainLocationUnavailable", code: 555, userInfo: nil))
            }
        }
        return promise
    }
    
    @discardableResult
    func submit() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("requestorder")
        
        let deviceID = DeviceToken.token
        var orderInfo = Order.current?.toJSON()
        let _ = orderInfo?.removeValue(forKey: "addresslist")
        var addresses:[Any]
        if toAddress != nil  {
            addresses = [self.fromAddress!.toJSON(), self.toAddress!.toJSON()]
        }else{
            addresses = [self.fromAddress!.toJSON()]
        }
        orderInfo?["user_device_id"] = deviceID ?? "IDNotAvailable"
        orderInfo?["accessToken"] = User.current.accessToken
        orderInfo?["paymenttype"] = Order.current?.payment?.type?.rawValue
        orderInfo?["gatewaytoken"] = ""
        orderInfo?["product_pk"] = Order.current?.service.productId
        let map = Map(mappingType: .toJSON, JSON: [:])
        addresses <- map["orderaddress"]
        orderInfo  <- map["userinfo"]
        let parameters = map.JSON
        return SessionManager.default.request(URL, method: .post, parameters: parameters, encoding : JSONEncoding.default).validateErrors().responseJSON(completionHandler: {response in
            if let _ = response.result.error { return }
            Order.current = nil
        })
    }
    
    @discardableResult
    func getPrice(_ distance: Double, service: Int, completionHandler: ((_ price: Double, _ error: Error?) -> ())?) -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("getprice")
        let accessToken = User.current.accessToken
        let paramters = ["product_pk": service, "accessToken": accessToken ?? "", "distance": distance] as [String : Any]
        return SessionManager.default.request(URL, method: .post, parameters: paramters, encoding : JSONEncoding.default).validate().responseJSON(completionHandler: {response in
            if let error = response.result.error {
                completionHandler?(0, error)
                return
            }
            let value = response.result.value as! Parameters
            let data  = value["data"] as! Parameters
            let price = data["price"] as! NSNumber
            completionHandler?(Double(price), nil)
        })
    }
}
extension Dictionary {
    static func += <K, V> ( left: inout [K:V], right: [K:V]) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
    }
}

