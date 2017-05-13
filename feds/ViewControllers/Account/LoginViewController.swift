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
import Eureka

class LoginViewController: FormViewController {
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupdummy()
    }
    private func setupdummy() {
        form.rowBy(tag: "username")?.baseValue = ProcessInfo.processInfo.environment["username"]
        form.rowBy(tag: "password")?.baseValue = ProcessInfo.processInfo.environment["password"]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func setupForm() {
        form +++ Section()
            <<< FDTextRow("username") {
                $0.title = I18n.t("Email")
                $0.add(rule: RuleRequired())
        }
            <<< FDTextRow("password") {
                $0.title = I18n.t("Password")
                $0.type = .secure
                $0.add(rule: RuleRequired())
        }
            <<< FDButtonRow() {
                $0.value = I18n.t("Login")
                $0.action = { self.login() }
        }
        
            <<< FDButtonRow() {
                $0.value = I18n.t("Register")
                $0.action = { self.register() }
        }
    }
    
    func login() {
        guard form.isValid else { return }
        KRProgressHUD.show()
        let username = form.rowBy(tag: "username")?.baseValue as! String
        let password = form.rowBy(tag: "password")?.baseValue as! String
        User.login(username, password).response(completionHandler : {[weak self] response in
            KRProgressHUD.dismiss()
            if let error = response.error {
                self?.show(error: error)
                return
            }
            self?.goHome()
        })

    }
    
    private func goHome() {
        guard let homeVc = UIStoryboard.home.instantiateInitialViewController() else { return }
        present(homeVc, animated: true, completion: {
            Router.shared.setRootViewcontroller(homeVc)
        })
    }
    
    func register() {
        guard let viewcontroller = storyboard?.instantiateViewController(withIdentifier: RegisterViewController.identifier) else { return }
        let navigationcontroller = FDNavigationController(rootViewController: viewcontroller)
        present(navigationcontroller, animated: true, completion: nil)
    }
    @IBAction func forgotTapped(_ sender: Any) {
        guard let viewcontroller = storyboard?.instantiateViewController(withIdentifier: ForgotPasswordViewController.identifier) else { return }
        let navigationcontroller = FDNavigationController(rootViewController: viewcontroller)
        present(navigationcontroller, animated: true, completion: nil)
    }
    
    func fbLogin() {
        
    }
}



/*
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin:UIButton!
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
            self?.goHome()
        })
    }
    func isValid() -> Bool {
        let isValid = (txtUsername.text != "") && (txtPassword.text != "")
        return isValid
    }
    
    func goHome() {
        let homeVc = UIStoryboard.home.instantiateInitialViewController()
        present(homeVc!, animated: true, completion: {
            Router.shared.setRootViewcontroller(homeVc!)
        })
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
        KRProgressHUD.show()
        User.current.logout().response(completionHandler: { response in
            KRProgressHUD.dismiss()
            Session.delete()
        })
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fbFlow()
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
        }else {
            fbPromise.reject(FBLoginError.loginError)
        }
    }
}

enum FBLoginError: Error {
    case loginError
}
 
 */
