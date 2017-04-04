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
    func isValid(value: RowValueType?) -> ValidationError? {
        return value == referenceRow.value ? nil : validationError
    }
    var id: String?
    var validationError: ValidationError
    var referenceRow: FDTextRow
    init(row: FDTextRow) {
        referenceRow = row
        validationError = ValidationError(msg: "Fields not equal")
    }
}
