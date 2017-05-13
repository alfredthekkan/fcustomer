//
//  TrackingViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/29/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import GoogleMaps

class TrackingViewController: UIViewController {

    var mapView:GMSMapView!
    var order:Order!

    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var imgDriverImageView:UIImageView!
    @IBOutlet weak var btnDriver:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = order.orderTokenId
        customizeUI()
        let camera = GMSCameraPosition.camera(withLatitude: 24.00,
                                                          longitude: 54.00, zoom: 10)
        var frame = self.view.bounds
        frame.size.height -= 47.5
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.insertSubview(mapView, at: 0)
        self.mapView = mapView
        let p = CLLocationCoordinate2DMake(24.4, 54.4)
        self.showMarkerAtPosition((order.toAddress?.coordinate)!,isDriver:false)
        self.showMarkerAtPosition(p, isDriver: true)
        setDriver()
    }
    
    
    private func setDriver() {
        guard let driver = order.driver else { return }
        imgDriverImageView.setImageUrl(order.driver?.url)
        phoneNumberButton.setTitle(driver.mobile, for: .normal)
        btnDriver.setTitle(driver.name, for: .normal)
    }
 fileprivate func showMarkerAtPosition(_ position:CLLocationCoordinate2D,isDriver:Bool) {
        let marker = GMSMarker(position: position)
        if isDriver {
            marker.icon = UIImage(named: "trackingPin")
        }else{
            marker.icon = UIImage(named: "deliverTo")
        }
        marker.map = self.mapView
    }
    
    fileprivate func customizeUI() {
        imgDriverImageView.makeRoundCorder()
    }
    
    @IBAction func btnCallTapped(_ sender:AnyObject) {
        guard let mobile = order.driver?.mobile else { return }
        guard let url = URL(string: "tel://\(mobile)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }else{
            self.view.showMessage("Cannot make calls to this number")
        }
    }
}
