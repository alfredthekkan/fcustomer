//
//  TextFieldTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 3/9/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Eureka

class _FDTextFieldTableViewCell<T: Equatable>: Cell<T> {
    override func update() {
        super.update()
        textLabel?.text = nil
    }
}

class TextFieldTableViewCell: _FDTextFieldTableViewCell<String>, CellType {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var titleeLabel: UILabel!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        height = { 80 }
    }
    override func update() {
        super.update()
        guard let row = self.row as? FDTextRow else {
            return
        }
        
        titleeLabel.text = row.title
        textField.placeholder = row.placeHolder
        textField.text = row.value
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        line.backgroundColor = GlobalConstants.THEME_COLOR
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        line.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        guard let row = self.row as? FDTextRow else {
            return
        }
        
        row.value = textField.text != nil ? textField.text : ""
    }
}

final class FDTextRow: Row<TextFieldTableViewCell>, RowType {
    var placeHolder : String?
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<TextFieldTableViewCell>(nibName: "TextFieldTableViewCell")
    }
}
