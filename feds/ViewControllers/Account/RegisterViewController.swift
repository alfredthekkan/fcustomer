//
//  RegisterViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import KRProgressHUD
import Eureka

class RegisterViewController: FormViewController {
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "REGISTER"
        navigationItem.rightBarButtonItem = self.cancelButton()
    }

    func setupForm() {
        tableView?.separatorStyle = .none
        form +++ Section()
            <<< FDTextRow("firstname") {
                $0.title = "Name"
                $0.placeHolder = "John Smith"
                var rule = RuleRequired<String>()
                rule.validationError = ValidationError(msg: "Name missing")
                $0.add(rule: rule)
            }
            <<< FDTextRow("password") {
                $0.type = .secure
                $0.title = "Password"
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
            <<< FDTextRow("email") {
                $0.title = "Email"
                $0.placeHolder = "john@xyz.com"
                $0.add(rule: RuleEmail())
                var rule = RuleRequired<String>()
                rule.validationError = ValidationError(msg: "Email missing")
                $0.add(rule: rule)
            }
            <<< FDTextRow("mobile") {
                $0.title = "Phone Number"
                $0.placeHolder = "05xxxxxxxx"
                var rule = RuleRequired<String>()
                rule.validationError = ValidationError(msg: "Mobile missing")
                $0.add(rule: rule)
            }
            <<< FDTextRow("lastname") {
                $0.title = "Name"
                $0.placeHolder = "John Smith"
                $0.value = "xxx"
                $0.hidden = true
        }
            <<< FDButtonRow () {
                $0.value = "Register"
                $0.action = { self.next() }
        }
    }
    
    
    func next() {
        if self.form.isValid {
            let input = form.unwrappedValues()
            KRProgressHUD.show()
            User.create(input).responseJSON(completionHandler: {[weak self] response in
                KRProgressHUD.dismiss()
                if let error = response.result.error {
                    self?.show(error: error)
                    return
                }
                User.isAuthorized = true
                guard let homeVC = UIStoryboard.home.instantiateInitialViewController() else { return }
                Router.shared.setRootViewcontroller(homeVC)
            })
        }else{
            if let msg = self.form.validate().first?.msg {
                self.show(title: "Error", message: msg)
            }
        }
    }
}

protocol AlertRepresentable {
    func show(error: Error)
    func show(message: String)
}

extension AlertRepresentable where Self: UIViewController {
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: (error as NSError).domain, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func show(message: String) {
        let alert = UIAlertController(title: "Feds", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: AlertRepresentable {}

extension Form {
    public func unwrappedValues(_ includeHidden: Bool = true) -> [String: Any]{
        let wrapped = self.values(includeHidden: includeHidden)
        
        var unwrapped = [String:Any]()
        
        for (k,v) in wrapped {
            unwrapped[k] = v ?? nil
        }
        
        return unwrapped
    }
    
    var isValid: Bool {
        rows.forEach { (row) in
            if let editableRow = row as? Editable {
                editableRow.endEditing()
            }
        }
        return validate().isEmpty
    }
}

protocol Editable {
    func endEditing()
}

extension FDTextRow: Editable {
    func endEditing() {
        cell.textField.resignFirstResponder()
    }
}
