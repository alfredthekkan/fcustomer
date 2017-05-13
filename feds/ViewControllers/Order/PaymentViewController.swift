//
//  PaymentViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/21/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

enum TextFieldInputType {
    case date
    case cvv
    case cardNumber
}

class LineTextField: UITextField {
   
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: rect.height - 10))
        
        aPath.addLine(to: CGPoint(x: rect.width, y: rect.height - 10))
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.red.set()
        aPath.stroke()
        //If you want to fill it as well 
        aPath.fill()
        
    }
    
}

class LineTextFieldControl:UIControl,UITextFieldDelegate {
    
    var inputType = TextFieldInputType.cardNumber
    
    var normalLineColor = UIColor.lightGray
    var highlightColor = UIColor.purple
    var lineWidth:CGFloat = 2
    
    var prefixImageName:String?
    var prefixText:String?
    
    var currentColor = UIColor.gray
    
    var line:UIBezierPath!
    
    var textField:UITextField!
    
    override func draw(_ rect: CGRect) {
        
        let w = rect.width
        let h:CGFloat = 30
        let x:CGFloat = 0
        let y:CGFloat = 0
        
        let f = CGRect(x: x, y: y, width: w, height: h)
        let tx = UITextField(frame: f)
        
        textField = tx
        
        if prefixText != nil {
            textField.prefixWithString(prefixText!)
        }
        
        if prefixImageName != nil {
            textField.prefixWithImageName(prefixImageName!)
        }
    
        tx.delegate = self
        
        self.addSubview(tx)
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: rect.height - lineWidth))
        
        aPath.addLine(to: CGPoint(x: rect.width, y: rect.height - lineWidth))
        
        aPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        aPath.addLine(to: CGPoint(x: 0, y: rect.height))
        
        aPath.close()
        
        //If you want to stroke it with a red color
        currentColor.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        line = aPath

    }
    
    // MARK: - TEXT FIELD DELEGATE
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        

        currentColor = highlightColor
        
        setNeedsDisplay()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentColor = normalLineColor
        
        setNeedsDisplay()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if inputType == .date { // if this is for date of expiry
            if textField.text?.characters.count == 1 && string != "" {
                textField.text = textField.text! + string + "/"
                return false
            }
        }else if inputType == .cvv {
            
            var count = 0
            if textField.text != "" {
                count = (textField.text?.characters.count)!
            }
            
            count += string.characters.count
            
            if count > 3 {
                return false
            }
        }else if inputType == .cardNumber {
            
            var count = 0
            if textField.text != "" {
                count = (textField.text?.characters.count)!
            }
            
            count += string.characters.count
            
            if count > 16 {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var txtCardNo:LineTextFieldControl!
    @IBOutlet weak var txtExpiryDate:LineTextFieldControl!
    @IBOutlet weak var txtCVV:LineTextFieldControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ADD PAYMENT"
        
        txtCardNo.prefixImageName = "creditCard"
        txtExpiryDate.prefixImageName = "calendar"
        txtCVV.prefixText = "CVV"
        
        
        txtCardNo.highlightColor = GlobalConstants.SOURCE_UNDERLINE_COLOR
        txtExpiryDate.highlightColor = GlobalConstants.SOURCE_UNDERLINE_COLOR
        txtCVV.highlightColor = GlobalConstants.SOURCE_UNDERLINE_COLOR

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtExpiryDate.textField.keyboardType = .numberPad
        txtExpiryDate.inputType = .date
        txtCVV.textField.keyboardType = .numberPad
        txtCVV.inputType = .cvv
        txtCardNo.textField.keyboardType = .numberPad
        txtCardNo.inputType = .cardNumber
        
        txtExpiryDate.textField.placeholder = "MM/YY"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnPayTapped(_ sender:AnyObject) {
        
    }

}
