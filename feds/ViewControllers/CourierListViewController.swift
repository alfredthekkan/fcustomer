//
//  CourierListViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/29/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

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
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
        
        
        let ip = NSDictionary(objects: [accessToken!], forKeys: ["accessToken" as NSCopying])
        
        WebServices.getAllOrders(ip as! [AnyHashable: Any], withSuccess: {
            
                responseData in
            
            do {
                
                if let response = responseData as? Data {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        print(jsonDict)
                        
                        
                        if let orderArray = jsonDict["data"] as? [NSDictionary] {
                            
                            for d in orderArray {
                                
                                print(d)
                                
//                                let order = Order(d: d)
//                                
//                                self.orderArray.append(order)
                                
                            }
                            
                            self.tableView.reloadData()
                            
                            
                        }
                        
                        
                        
                    }
                }
                
                
                
            }catch{
                
            }
            
            }, failure: {
                
                error in
                
                print(error)
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
        cell.lblPrice.text = "PRICE - \(order.price) AED"
        cell.lblLocationName.text = "DELIVERY - \(order.fromAddress.address) - \(order.toAddress.address)"
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let iv = UIImageView(frame: frame)
        iv.contentMode = .scaleAspectFit
        
        switch order.service {
        case .bike:
            iv.image = UIImage(named: "bike_service")
        case .car :
            iv.image = UIImage(named: "car_service")
        case .van:
            iv.image = UIImage(named: "truck_service")
        default:
            print("unknown choice")
        }
        cell.accessoryView = iv
        cell.backgroundColor = GlobalConstants.THEME_COLOR
        let bv = UIView(frame: cell.frame)
        bv.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        cell.selectedBackgroundView = bv
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
        let or = orderArray[indexPath.row]
        x.order = or
        navigationController?.pushViewController(x, animated: true)
    }
}























