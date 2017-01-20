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
        getPlaceName()
        
        //TODO: - Get the right payment method
        Order.current?.payment = Payment(type: .creditCard)
    }
    private func getPlaceName() {
        Order.current?.fromAddress?.coordinate.getPlaceName{ [weak self] place, error in
            if error != nil { return }
            Order.current?.fromAddress?.address = place
            self?.form.rowBy(tag: "source")?.baseValue = place
        }
        Order.current?.toAddress?.coordinate.getPlaceName{ [weak self] place, error in
            if error != nil { return }
            Order.current?.toAddress?.address = place
            self?.form.rowBy(tag: "destination")?.baseValue = place
        }
    }
    private func setupForm() {
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 50
        form +++ Section()
        <<< LocationTitleRow("source"){ row in
                row.type = .source
            }.onChange{[weak self] in
                $0.updateCell()
                let ip = self?.tableView?.indexPath(for: $0.cell)
                self?.tableView?.reloadRows(at: [ip!], with: .none)
            }
        <<< LocationTitleRow("destination"){ row in
                row.type = .destination
            }.onChange{[weak self] in
                $0.updateCell()
                let ip = self?.tableView?.indexPath(for: $0.cell)
                self?.tableView?.reloadRows(at: [ip!], with: .none)
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
        Order.current?.submit().response{[weak self] response in
            if let _ = response.error { return }
            if let identifier = self?.defaultStoryBoardIdentifier {
                self?.performSegue(withIdentifier: identifier, sender: nil)
            }
        }
    }
    private func getPrice(_ service: Int) {
        Order.current?.fromAddress?.getDistance(fromAddress: (Order.current?.toAddress)!){distance, error in
            if let distanceMeter = distance?.rows?[0].elements?[0].distance?.value {
                Order.current?.distance = distanceMeter/1000
                Order.current?.getPrice(distanceMeter/1000, service: service){[weak self]price, error in
                    if error != nil { return }
                    self?.priceLabel.text = "\(price) AED"
                    Order.current?.price = price
                }
            }
        }
    }
}

extension OrderSubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        itemImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

