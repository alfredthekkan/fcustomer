//
//  UIExtensions.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIView {
    
    func showMessage(_ msg:String) {
        let lbl = UILabel(frame: CGRect(x: 0,y: 0,width: self.bounds.width,height: 0))
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = msg
        lbl.sizeToFit()
        
        if lbl.frame.size.width < self.frame.width {
            lbl.frame = CGRect(x: 0, y: lbl.frame.origin.y, width: frame.width, height: lbl.frame.height)
        }
        
        if lbl.frame.size.height < 60 {
            lbl.frame = CGRect(x: 0, y: lbl.frame.origin.y, width: frame.width, height: 60)
        }
        
        lbl.frame.origin = CGPoint(x: 0, y: self.bounds.height - lbl.frame.height)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.black
        lbl.layer.cornerRadius = 3.0
        lbl.layer.shadowOpacity = 4.0
        lbl.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        addSubview(lbl)
        UIView.animate(withDuration: 0.5, delay: 3.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            lbl.alpha = 0
            
            
            }, completion: nil)
        
    }
}

extension UINavigationBar{
    func modifyNavigationBar(){
        let img = UIImage(named: "pattern")
        
        //barTintColor = UIColor(patternImage: img!)
        barTintColor = UIColor.yellow
    }
}

extension UITextField {

    ///Adds the image with name str at the beginning of the textfield
    
    func prefixWithImageName(_ str:String) {
        let f = CGRect(x: 0, y: 0, width: 30, height: 30)
        let iv = UIImageView(frame: f)
        iv.contentMode = .center
        iv.image = UIImage(named: str)
        
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = iv
    }
    
    ///Adds the image with name str at the end of the textfield
    
    func postfixWithImageName(_ str:String) {
        let f = CGRect(x: 0, y: 0, width: 30, height: 30)
        let iv = UIImageView(frame: f)
        iv.contentMode = .center
        iv.image = UIImage(named: str)
        
        self.rightViewMode = UITextFieldViewMode.always
        self.rightView = iv
    }
    
    func showValidation(_ isValid:Bool){
        if isValid {
            postfixWithImageName("rightTickMark")
        }else{
            postfixWithImageName("wrongTickMark")
        }
    }
    
    func postfixDropDown(){
        let f = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let lbl = UILabel(frame: f)
        
        lbl.text = "▼"
        
        self.rightViewMode = UITextFieldViewMode.always
        self.rightView = lbl
    }
    
    func prefixWithString(_ str:String){
        let f = CGRect(x: 0, y: 0, width: 50, height: 20)
        let lbl = UILabel(frame: f)
        lbl.text = " \(str)"
        
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = lbl
    }
}

extension UILabel{
    func requiredHeight(_ wid:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: wid, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
}

extension String {
    func isValidEmail() -> Bool {
        
    
        
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isValid = emailTest.evaluate(with: self)
        
        
        return isValid
    }
}

extension UIImageView {
    
    func makeRoundCorder() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true
    }
    
    func addLightShadow() -> Void {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 5
        
    }
    
    func setImageUrl(_ imageUrl: String?) {
        guard let url = imageUrl else { return }
        Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else {
                return
            }
            self.image = image
        }
    }
    
}

extension UIViewController {
    var defaultStoryBoardIdentifier: String? {
        if let templates = value(forKey: "storyboardSegueTemplates") as! [AnyObject]? {
            if let id = templates.first?.value(forKey: "identifier") as? String {
                return id
            }
        }
    return nil
    }
    var alternateStoryBoardIdentifier: String? {
        if let templates = value(forKey: "storyboardSegueTemplates") as! [AnyObject]? {
            if let id = templates.second?.value(forKey: "identifier") as? String {
                return id
            }
        }
        return nil
    }
    
    
    func show(title: String, message: String, completionHandler: (() -> ())? = nil ) {
        MTPopUp(frame: self.view.frame).show(complete: { (index) in
            completionHandler?()
            //Set your custom code here as per index.
        },
                                             view: self.view,
                                             animationType: MTAnimation.TopToMoveCenter,
                                             strMessage: message,
                                             btnArray: ["Done"],
                                             strTitle: title)
    }
}

extension Array {
    var second: Element? {
        guard self.count >= 2 else { return nil }
        return self[1]
    }
    var lastButOne: Element? {
        guard self.count >= 2 else {
            return nil
        }
        return self[self.count - 1]
    }
}

