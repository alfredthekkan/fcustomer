//
//  UIExtensions.swift
//  Fedex
//
//  Created by TMC-4 on 6/7/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

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
//        UIView.animateWithDuration(3.0, animations: {
//            
//            lbl.alpha = 0
//            
//            }, completion: { animated in
//                
//                lbl.removeFromSuperview()
//        })
        
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
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        print("label width is \(self.frame.width)")
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
        
        
    }
    
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
        //self.layer.borderWidth = 1.0
        //self.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.clipsToBounds = true
    }
    
    func addLightShadow() -> Void {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 5
        
    }
    
}
