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
        
        title = "REGISTER"
    }

    func setupForm() {
        tableView?.separatorStyle = .none
        form +++ Section()
            <<< FDTextRow("firstname") {
                $0.title = "Name"
                $0.placeHolder = "John Smith"
            }
            <<< FDTextRow("password") {
                $0.title = "Password"
                $0.placeHolder = "●●●●"
            }
            <<< FDTextRow("confirmPassword") {
                $0.title = "Confirm Password"
                $0.placeHolder = "●●●●"
                if let passwordRow = form.rowBy(tag: "password") as? FDTextRow {
                    $0.add(rule: RuleEqual(row: passwordRow))
                }
            }
            <<< FDTextRow("email") {
                $0.title = "Email"
                $0.placeHolder = "john@xyz.com"
            }
            <<< FDTextRow("mobile") {
                $0.title = "Phone Number"
                $0.placeHolder = "05xxxxxxxx"
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
        let input = form.unwrappedValues()
        KRProgressHUD.show()
        User.create(input).responseJSON(completionHandler: {[weak self] response in
            KRProgressHUD.dismiss()
            if let error = response.result.error {
                self?.show(error: error)
                return
            }
            //HomeSegue
            self?.performSegue(withIdentifier: "HomeSegue", sender: nil)
        })
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
    }}
