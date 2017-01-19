//
//  OrderSubmitViewController.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import CoreLocation

class OrderSubmitViewController: FormViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    private func setupForm() {
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 50
        form +++ Section()
            <<< LabelRow() { row in
                Order.current?.fromAddress.coordinate.getPlaceName{ place, error in
                    if error != nil { return }
                    row.value = place
                    Order.current?.fromAddress.address = place
                    row.updateCell()
                }
            }
            <<< LabelRow() { row in
                Order.current?.toAddress.coordinate.getPlaceName{ place, error in
                    if error != nil { return }
                    row.value = place
                    Order.current?.toAddress.address = place
                    row.updateCell()
                }
            }
            <<< ServiceRow() {
                $0.value = Service.createService(.bike)
                }.onCellSelection({[weak self] cell, row in
                    self?.getPrice(1)
                })
            <<< ServiceRow() {
                $0.value = Service.createService(.car)
                }.onCellSelection({[weak self] cell, row in
                    self?.getPrice(2)
                })
            <<< ServiceRow() {
                $0.value = Service.createService(.van)
                }.onCellSelection({[weak self] cell, row in
                    self?.getPrice(3)
                })
    }
    @IBAction func addPicture(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        Order.current?.submit()
    }
    private func getPrice(_ service: Int) {
        Order.current?.fromAddress.getDistance(fromAddress: (Order.current?.toAddress)!){distance, error in
             let distanceMeter = distance?.rows?[0].elements?[0].distance?.value
            Order.current?.getPrice(distanceMeter!, service: service){[weak self]price, error in
                if error != nil { return }
                self?.priceLabel.text = "\(price)"
            }
        }
    }
}

extension OrderSubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        itemImageView.image = info[UIImagePickerControllerEditedImage] as! UIImage?
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
