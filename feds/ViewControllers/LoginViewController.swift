//
//  LoginViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import Alamofire

import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var forgotPassword:UIButton!
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var lblOr:UILabel!
    @IBOutlet weak var btnFbLogin:FBSDKLoginButton!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var contentView:UIView!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        addLoginButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(_ notification:Notification){
        var offset:CGFloat = 0
        if txtPassword.isFirstResponder {
            offset = 90
        }
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + offset
        self.scrollView.contentInset = contentInset
    }
    func keyboardWillHide(_ notification:Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }

    fileprivate func customizeUI(){
        btnLogin.backgroundColor = GlobalConstants.THEME_COLOR
        btnRegister.backgroundColor = GlobalConstants.THEME_COLOR
        lblEmail.textColor = GlobalConstants.THEME_COLOR
        lblPassword.textColor = GlobalConstants.THEME_COLOR
        lblOr.textColor = GlobalConstants.THEME_COLOR
    }
    @IBAction func loginAction(_ sender: AnyObject) {
        view.endEditing(true)
        if !isValid() { return }
        let username = txtUsername.text!
        let password = txtPassword.text!
        User.login(username, password).response(completionHandler : {[weak self] response in
            if let error = response.error {
                print("Error: \(error.localizedDescription)")
                return
            }
            let x = self?.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self?.present(x!, animated: true, completion: nil)
        })
    }
    func isValid() -> Bool {
        let isValid = (txtUsername.text != "") && (txtPassword.text != "")
        return isValid
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let x = textField.text {
            let str = x + string
            if str.isValidEmail() {
                textField.postfixWithImageName("rightTickMark")
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtUsername {
            if let x = textField.text {
                if x.isValidEmail() {
                    textField.postfixWithImageName("rightTickMark")
                }else{
                    textField.postfixWithImageName("wrongTickMark")
                }
            }
        }
    }
    
    fileprivate func addLoginButton() {
        let loginbutton = FBSDKLoginButton()
        self.btnFbLogin = loginbutton
        loginbutton.translatesAutoresizingMaskIntoConstraints = false
        self.btnFbLogin.readPermissions = ["email"]
        contentView.addSubview(loginbutton)
        let leadingConstraint = NSLayoutConstraint(item: loginbutton, attribute: .leading, relatedBy: .equal, toItem: btnRegister, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: loginbutton, attribute: .trailing, relatedBy: .equal, toItem: btnRegister, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: loginbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let verticalConstraint = NSLayoutConstraint(item: loginbutton, attribute: .top, relatedBy: .equal, toItem: btnRegister, attribute: .bottom, multiplier: 1.0, constant: 24)
        contentView.addConstraints([leadingConstraint,trailingConstraint,heightConstraint,verticalConstraint])
    }
}
