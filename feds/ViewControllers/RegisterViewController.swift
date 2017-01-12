//
//  RegisterViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import SwiftLoader

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtpassword:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnNeedHelp:UIButton!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    
    @IBOutlet weak var navBar:UINavigationBar!
    @IBOutlet weak var scrollView:UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        customizeUI()
        
        addBarButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    
        
    }
    
    fileprivate func customizeUI(){

        btnRegister.backgroundColor = GlobalConstants.THEME_COLOR
        
        lblName.textColor = GlobalConstants.THEME_COLOR
        lblEmail.textColor = GlobalConstants.THEME_COLOR
        lblPassword.textColor = GlobalConstants.THEME_COLOR
        lblPhoneNumber.textColor = GlobalConstants.THEME_COLOR
        
        
        
        navBar.barTintColor = GlobalConstants.THEME_COLOR
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
      
        view.backgroundColor = GlobalConstants.THEME_COLOR
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    fileprivate func addBarButton() {
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(RegisterViewController.backButtonTapped(_:)))
        backButton.tintColor = UIColor.white
        
        navBar.pushItem(navigationItem, animated: false)
        
        navigationItem.title = "REGISTER"
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    @IBAction func backButtonTapped(_ sender:AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func registerTapped(_ sender:AnyObject) {
        
        view.endEditing(true)
        
        let username = txtName.text
        let password = txtpassword.text
        let email = txtEmail.text
        let phoneNumber = txtPhoneNumber.text
        //:{"firstname":"kotesh","lastname":"madikanti","mobile":"9848868560","email":"kotesh@gmail.com"}
        let inputDict = NSDictionary(objects: [username!,password!,email!,phoneNumber!,"test last name"], forKeys: ["firstname" as NSCopying,"password" as NSCopying,"email" as NSCopying,"mobile" as NSCopying,"lastname" as NSCopying])
        
        SwiftLoader.show(title: "Loading", animated: true)
        
        WebServices.submitRegisterData(inputDict as! [AnyHashable: Any], withSuccess: {
            response in
            
            SwiftLoader.hide()
            
            
            if let responseData = response as? Data {
                let newStr = String(data: responseData, encoding: String.Encoding.utf8)
                
                print(newStr)
            }
            
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: response! as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let d = jsonDict["data"] as? NSDictionary {
                    
                
                    print(jsonDict)
                    
                    if let accessToken = d["accessToken"] as? String {
                        UserDefaults.standard.set(accessToken, forKey: GlobalConstants.KEY_ACCESS_TOKEN)
                    }
                    
                    let x = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                    self.present(x!, animated: true, completion: nil)
                    
                    
                }else{ // This is error case
                    
                    let msg = jsonDict["message"] as! String
                    self.view.showMessage(msg)
                    
                    
                    
                }
                
            }catch{
                print("exception occured")
            }
            
            
            
            }, failure: {
                error in
                
                if let data = ( error as! NSError).userInfo[GlobalConstants.AFNETWORKING_ERROR_KEY] as? Data {
                    
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            if let dataDict = jsonDict["data"] as? NSDictionary {
                                if let errorStr = dataDict["error"] {
                                    print(errorStr)
                                }
                            }
                        }
                    }catch {
                        print("Exception Occurred")
                    }
                    
                    
                }
                
                SwiftLoader.hide()
                
                
        })
    }
    
    func keyboardWillShow(_ notification:Notification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 90
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    
    // MARK: Text Field Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtEmail {
            
            if let x = textField.text {
                
                
                if x.isValidEmail() {
                    
                    textField.postfixWithImageName("rightTickMark")
                    
                }else{
                    
                    textField.postfixWithImageName("wrongTickMark")
                }
            }
            
        }else if textField == txtPhoneNumber {
            func validate(_ value: String) -> Bool {
                let PHONE_REGEX = "^0\\d{9}$"
                let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
                let result =  phoneTest.evaluate(with: value)
                return result
            }
            
            if let x = textField.text {
                if validate(x) {
                    textField.postfixWithImageName("rightTickMark")
                }else{
                    textField.postfixWithImageName("wrongTickMark")
                }
            }else {
                textField.postfixWithImageName("wrongTickMark")
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtpassword.becomeFirstResponder()
        }else if textField == txtpassword {
            txtEmail.becomeFirstResponder()
        }else if textField == txtEmail {
            txtPhoneNumber.becomeFirstResponder()
        }else if textField == txtPhoneNumber {
            textField.resignFirstResponder()
        }
        return true
    }

    
    
    
    
    

}
