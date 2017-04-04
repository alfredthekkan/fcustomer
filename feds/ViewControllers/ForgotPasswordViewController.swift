//
//  ForgotPasswordViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 4/3/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
class ForgotPasswordViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        setupForm()
        // Do any additional setup after loading the view.
    }
    
    //Setup form
    private func setupForm() {
        form +++ Section()
        <<< FDTextRow("email") {
                $0.title = "Email"
                $0.placeHolder = "john.smith@gmail.com"
        }
        <<< FDButtonRow () {
                $0.value = "Send Email"
                $0.action = { self.next() }
        }
    }
    
    //MARK: User Interaction
    private func next() {
        let input = form.unwrappedValues()
        User.forgotPassword(input).response { (response) in
            if let error = response.error {
                self.show(error: error)
                return
            }
            self.show(title: "FEDS", message: "A recovery link has been sent to your email.")
        }
    }
}
