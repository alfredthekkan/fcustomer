//
//  AddressViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 5/5/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class AddressViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    private func setupForm() {
        form +++ Section()
        <<< FDTextRow("building") {
            $0.placeHolder = "Building Name"
            $0.add(rule: RuleRequired<String>())
        }
        <<< FDTextRow("flat") {
            $0.placeHolder = "Flat No"
            $0.add(rule: RuleRequired<String>())
        }
            <<< FDTextRow("emirate") {
                $0.placeHolder = "Emirate"
        }
            <<< LocationRow() {
                $0.title = "Choose Location"
        }
    }
}
