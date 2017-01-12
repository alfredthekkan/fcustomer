
//
//  TempViewController.swift
//  Fedex
//
//  Created by TMC-4 on 7/17/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit




class TempViewController: UIViewController {
    
    @IBAction func testFun(_ sender:UIButton) {
        
        
        let d1 = NSDictionary(objects: ["value1","value2"], forKeys: ["key1" as NSCopying,"key2" as NSCopying])
        let a1 = [d1,d1,d1,d1]
        let d2 = NSDictionary(object: a1, forKey: "key3" as NSCopying)
        
        
        
        
        WebServices.testService(d2 as! [AnyHashable: Any], withSuccess: {
            response in
            
            if let responseData = response as? Data {
                let newStr = String(data: responseData, encoding: String.Encoding.utf8)
                
                print(newStr!)
            }
        
        
            
            }, failure: {
                error in
        
        })
    }

}


