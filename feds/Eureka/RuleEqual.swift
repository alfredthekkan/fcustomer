//
//  RuleEqual.swift
//  feds
//
//  Created by Alfred Thekkan on 3/31/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Eureka

class RuleEqual: RuleType {
    typealias RowValueType = String
    var id: String?
    var validationError: ValidationError
    var form: Form!
    var otherRowTag: String
    
    init(form: Form, msg: String = "Fields doesn't match", tag: String) {
        otherRowTag = tag
        validationError = ValidationError(msg: msg)
        self.form = form
    }
    
    func isValid(value: RowValueType?) -> ValidationError? {
        if let otherRowValue = form.rowBy(tag: otherRowTag)?.baseValue as? RowValueType {
            if value == otherRowValue {
                return nil
            }else{
                return validationError
            }
        }
        return nil
    }
    

}
