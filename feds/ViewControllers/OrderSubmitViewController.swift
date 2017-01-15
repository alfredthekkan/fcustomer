//
//  OrderSubmitViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class OrderSubmitViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    private func setupForm() {
        form +++ Section()
            <<< ServiceRow() {
                $0.value = Service.createService(.bike)
        }
            <<< ServiceRow() {
                $0.value = Service.createService(.car)
        }
            <<< ServiceRow() {
                $0.value = Service.createService(.van)
        }
    }
}
