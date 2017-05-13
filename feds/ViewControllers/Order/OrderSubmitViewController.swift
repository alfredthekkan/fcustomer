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
import KRProgressHUD

class OrderSubmitViewController: FormViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        getPlaceName()
        _addBarbuttons()
        getDistance()
        //TODO: - Get the right payment method
        Order.current?.payment = Payment(type: .creditCard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "ORDER SUMMARY"
    }
    //MARK: - Private Methods
    private func getPlaceName() {
        Order.current?.fromAddress?.coordinate?.getPlaceName{ [weak self] place, error in
            if error != nil { return }
            Order.current?.fromAddress?.address = place
            self?.form.rowBy(tag: "source")?.baseValue = place
        }
        Order.current?.toAddress?.coordinate?.getPlaceName{ [weak self] place, error in
            if error != nil { return }
            Order.current?.toAddress?.address = place
            self?.form.rowBy(tag: "destination")?.baseValue = place
        }
    }
    private func _addBarbuttons() {
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(OrderSubmitViewController.homeTapped))
        navigationItem.rightBarButtonItem = homeButton
    }
    func homeTapped() {
        performSegue(withIdentifier: "unwind", sender: nil)
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
         <<< ServiceRow("bike") {
                $0.value = Service.createService(.bike)
                }.onCellSelection({[weak self] cell, row in
                    self?.priceLabel.text = "30 AED"
                    Order.current?.price = 30
                    Order.current?.service = .bike
                    cell.setSelected(true, animated: true)
                    self?.form.rowBy(tag: "car")?.baseCell.setSelected(false, animated: true)
                })
         <<< ServiceRow("car") {
               $0.value = Service.createService(.car)
                Order.current?.service = .car
                }.onCellSelection({[weak self] cell, row in
                    self?.priceLabel.text = "40 AED"
                    Order.current?.price = 40
                    cell.setSelected(true, animated: true)
                    self?.form.rowBy(tag: "bike")?.baseCell.setSelected(false, animated: true)
                })
    }
    //MARK: - IBActions
    @IBAction func addPicture(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        if Order.current?.service == .invalid {
            show(title: "Error", message: "Please select a service")
            return
        }
        KRProgressHUD.show()
        Order.current?.submit().response{[weak self] response in
            KRProgressHUD.dismiss()
            if let error = response.error {
                self?.show(title: "Error", message: error.localizedDescription)
                return
            }
            self?.show(title: "Order", message: "Submitted successfully") {
                if let identifier = self?.defaultStoryBoardIdentifier {
                    self?.performSegue(withIdentifier: identifier, sender: nil)
                }
            }
        }
    }
    //MARK: - Private Methods
    private func getDistance() {
        if let destination = Order.current?.toAddress {
            Order.current?.fromAddress?.getDistance(fromAddress: destination){distance, error in
                if let distanceMeter = distance?.rows?[0].elements?[0].distance?.value {
                    Order.current?.distance = distanceMeter/1000
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

