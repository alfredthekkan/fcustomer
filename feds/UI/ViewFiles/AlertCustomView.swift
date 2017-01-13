//
//  AlertCustomView.swift
//  Fedex
//
//  Created by TMC-4 on 6/15/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

class AlertCustomView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    
    var onApprove   :(() -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    //MARK: - Private Methods
    private func commonInit() {
        let nibView = Bundle.main.loadNibNamed("CustomAlert", owner: self, options: nil)?[0] as! UIView
        nibView.frame = self.bounds;
        self.addSubview(nibView)
        view.backgroundColor = UIColor.white
        lblQuestion.textColor = GlobalConstants.THEME_COLOR
    }
    
    @IBAction func yesTapped(_ sender:AnyObject) {
        removeFromSuperview()
        onApprove?()
    }
    
    @IBAction func noTapped(_ sender:AnyObject) {
        removeFromSuperview()
    }
}

