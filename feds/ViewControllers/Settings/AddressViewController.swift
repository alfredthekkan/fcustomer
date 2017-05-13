//
//  AddressViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 5/5/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation

class AddressViewController: FormViewController {
    
    enum AddessType: String {
        case home = "Home Address"
        case work = "Office Address"
    }

    var type = AddessType.home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = type.rawValue
        setupForm()
    }
    
    private func setupForm() {
        
        let savedData = UserDefaults.standard.object(forKey: type.rawValue) as? [String: Any]
        form +++ Section()
        <<< FDTextRow("building") {
            $0.placeHolder = "Building Name"
            $0.add(rule: RuleRequired<String>())
            $0.value = savedData?[$0.tag!] as! String?
        }
        <<< FDTextRow("flat") {
            $0.placeHolder = "Flat No"
            $0.add(rule: RuleRequired<String>())
            $0.value = savedData?[$0.tag!] as! String?
        }
            <<< FDTextRow("emirate") {
                $0.placeHolder = "Emirate"
                $0.value = savedData?[$0.tag!] as! String?
        }
            <<< LocationRow("location") {
                $0.title = "Choose Location"
                guard let str = savedData?[$0.tag!] as? String else { return }
                $0.value = CLLocation(str)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _saveAddress()
    }
    
    private func _saveAddress() {
        var values = form.unwrappedValues()
        
        if let loc = (values["location"] as? CLLocation)?.coordinate {
            let str = "\(loc.latitude)|\(loc.longitude)"
            values["location"] = str
        }
        UserDefaults.standard.set(values, forKey: type.rawValue)
    }
}

extension CLLocation {
    convenience init?(_ locString: String?) {
        guard let str = locString else { return nil }
        guard let lat = Double(str.components(separatedBy: "|").first!) else { return nil }
        guard let long  = Double(str.components(separatedBy: "|").second!) else { return nil }
        self.init(latitude: lat, longitude: long)
    }
}

