//
//  AlertCustomView.swift
//  Fedex
//
//  Created by TMC-4 on 6/15/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

protocol AlertCustomViewDelegate {
    func alertResponseSelected(_ status:Bool);
}

class AlertCustomView: UIView {
    
 
    @IBOutlet var view: UIView!
    @IBOutlet var lblQuestion: UILabel!
    
    var delegate:AlertCustomViewDelegate!

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        
    }
    
    fileprivate func commonInit() {
        let nibView = Bundle.main.loadNibNamed("CustomAlert", owner: self, options: nil)?[0] as! UIView
        nibView.frame = self.bounds;
        self.addSubview(nibView)
        view.backgroundColor = UIColor.white
        
        
        lblQuestion.textColor = GlobalConstants.THEME_COLOR

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    @IBAction func yesTapped(_ sender:AnyObject) {
        delegate.alertResponseSelected(true)
    }
    
    @IBAction func noTapped(_ sender:AnyObject) {
        delegate.alertResponseSelected(false)
    }
    
    
}

