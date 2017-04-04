//
//  TestViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 3/9/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class TestViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupForm()
    }
    private func setupForm() {
        form +++ Section()
            <<< FDTextRow() {
                $0.value = "Test value"
        }
    }
}
