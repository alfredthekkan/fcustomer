//
//  SettingsViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 5/12/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    private func setupForm() {
        form +++ Section()
            <<< LabelRow() {
                $0.title = "Home Address"
                }.onCellSelection({ [weak self] (cell, row) in
                    self?.showAddress(row)
                })
            <<< LabelRow() {
                $0.title = "Office Address"
                }.onCellSelection({ [weak self] (cell, row) in
                    self?.showAddress(row)
                })
            <<< LabelRow() {
                $0.title = "Change Password"
                }.onCellSelection({ [weak self] (cell, row) in
                    self?.performSegue(withIdentifier: "ChangePassword", sender: nil)
                })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Settings"
    }
    
    private func showAddress(_ row: LabelRow) {
        guard let addressViewController = storyboard?.instantiateViewController(withIdentifier: AddressViewController.identifier) else { return }
        addressViewController.title = row.title
        navigationController?.pushViewController(addressViewController, animated: true)
    }
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) { }
}
