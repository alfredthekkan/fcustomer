//
//  FDButtonTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 3/11/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class FDButtonTableViewCell: Cell<String>, CellType {
    
    
    @IBOutlet weak var button: UIButton!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        height = { 60 }
    }
    
    override func update() {
        super.update()
        guard let row = self.row as? FDButtonRow else { return }
        button.setTitle(row.value?.uppercased(), for: .normal)
    }
    @IBAction func didTapButton(_ sender: Any) {
        guard let row = self.row as? FDButtonRow else { return }
        row.action?()
    }
}


final class FDButtonRow: Row<FDButtonTableViewCell>, RowType {
    var action: (() -> ())?
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<FDButtonTableViewCell>(nibName: FDButtonTableViewCell.identifier)
    }
}
