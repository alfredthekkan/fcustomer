//
//  LoginViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import KRProgressHUD
import PromiseKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnForgot:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var lblOr:UILabel!
    @IBOutlet weak var btnFbLogin:FBSDKLoginButton!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var contentView:UIView!
    
    var fbPromise =  Promise<String>.pending()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        addLoginButton()
        fbFlow()
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
        
        KRProgressHUD.show()
        User.login(username, password).response(completionHandler : {[weak self] response in
            KRProgressHUD.dismiss()
            if let error = response.error {
                self?.show(error: error)
                return
            }
            User.isAuthorized = true
            let x = self?.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self?.present(x!, animated: true, completion: nil)
        })
    }
    func isValid() -> Bool {
        let isValid = (txtUsername.text != "") && (txtPassword.text != "")
        return isValid
    }
    
    func goHome() {
        let x = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        view.window?.rootViewController = x
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
        self.btnFbLogin.delegate = self
        contentView.addSubview(loginbutton)
        let leadingConstraint = NSLayoutConstraint(item: loginbutton, attribute: .leading, relatedBy: .equal, toItem: btnRegister, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: loginbutton, attribute: .trailing, relatedBy: .equal, toItem: btnRegister, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: loginbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let verticalConstraint = NSLayoutConstraint(item: loginbutton, attribute: .top, relatedBy: .equal, toItem: btnRegister, attribute: .bottom, multiplier: 1.0, constant: 24)
        contentView.addConstraints([leadingConstraint,trailingConstraint,heightConstraint,verticalConstraint])
    }
    
     func fbFlow() {
        fbPromise.promise.then { email -> Promise<Void> in
            self.sendTokenToServer(FBSDKAccessToken.current().tokenString, email)
            }.then { _ -> Void in
                User.isAuthorized = true
                self.goHome()
            }.catch { error in
                self.show(error: error)
        }
    }
    
    func sendTokenToServer(_ token: String, _ email: String) -> Promise<Void>{
        return Promise<Void> { fulfill, reject in
            KRProgressHUD.show()
            User.fbLogin(token,email).response(completionHandler : { response in
                KRProgressHUD.dismiss()
                if let error = response.error {
                    reject(error)
                }
                fulfill()
            })
        }
    }
    
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            fbPromise.reject(error)
        }
        if result.token != nil  {
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result.token.tokenString, version: nil, httpMethod: "GET")
            let _ = req?.start(completionHandler: { (_, result, error) -> Void in
                if(error == nil)
                {
                    print("result \(result)")
                    if let val = result as? [String: Any] {
                        let email = val["email"] as! String
                        self.fbPromise.fulfill(email)
                    }
                }
                else
                {
                    self.fbPromise.reject(error!)
                }
            })
            
            //fbPromise.fulfill(result.token.tokenString)
        }else {
            fbPromise.reject(FBLoginError.loginError)
        }
        
        
        
    }
}

enum FBLoginError: Error {
    case loginError
}
