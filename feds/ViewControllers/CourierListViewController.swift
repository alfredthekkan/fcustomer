//
//  CourierListViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/29/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import KRProgressHUD

class CourierListViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableView:UITableView!
    
    // data
    var orderArray = [Order]()
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY COURIERS"
        getOrders()
    }

    private func getOrders() {
        KRProgressHUD.show()
        Order.fetch(completionHandler: {[weak self] orders, error in
            KRProgressHUD.dismiss()
            if orders != nil {
                if orders!.count > 0  {
                    self?.orderArray = orders!.reversed()
                    self?.tableView.reloadData()
                }else{
                    self?.show(title: "Information", message: "No Orders Found!")
                }
                
            }
        })
    }
}

extension CourierListViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderArray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orderArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CourierTableViewCell
        cell.setupOrder(order)
        return cell
    }
}

extension CourierListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let x = self.storyboard?.instantiateViewController(withIdentifier: "DeliverTracking") as! TrackingViewController
        let order = orderArray[indexPath.row]
        x.order = order
        navigationController?.pushViewController(x, animated: true)
    }
}























