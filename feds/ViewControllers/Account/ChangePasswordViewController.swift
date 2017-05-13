//
//  ChangePasswordViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 5/12/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class ChangePasswordViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        self.title = "Change Password"
    }
    
    private func setupForm() {
        form +++ Section()
            <<< FDTextRow("password") {
                $0.type = .secure
                $0.title = "New Password"
                $0.placeHolder = "●●●●"
                var rule = RuleRequired<String>()
                rule.validationError = ValidationError(msg: "Password missing")
                $0.add(rule: rule)
            }
            <<< FDTextRow("confirmPassword") {
                $0.type = .secure
                $0.title = "Confirm Password"
                $0.placeHolder = "●●●●"
                var rule = RuleRequired<String>()
                rule.validationError = ValidationError(msg: "Confirm password missing")
                $0.add(rule: rule)
                $0.add(rule: RuleEqual(form: self.form, msg: "Password mismatch", tag: "password"))
        }
            <<< FDButtonRow () {
                $0.value = "Change Password"
                $0.action = { self.next() }
        }
    }
    
    func next() {
        guard form.isValid else { self.show(message: "Please fill all the field properly")
            return
        }
        guard let password = form.rowBy(tag: "password")?.baseValue as? String else { return }
        let passwordObj = Password(password)
        passwordObj.update().response { [weak self] response  in
            if let error = response.error {
                self?.show(error: error)
            }
            self?.show(title: "Change Password", message: "Successful", completionHandler: {
                if let identifier = self?.defaultStoryBoardIdentifier {
                    self?.performSegue(withIdentifier: identifier, sender: nil)
                }
            })
        }
    }
}
