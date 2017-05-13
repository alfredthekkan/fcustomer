//
//  TrackingViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/29/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import GoogleMaps
import PromiseKit

class TrackingViewController: UIViewController {

    var mapView:GMSMapView!
    var order:Order!

    enum MarkerType {
        case source
        case destination
        case driverPosition
    }
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var imgDriverImageView:UIImageView!
    @IBOutlet weak var btnDriver:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = order.orderTokenId
        customizeUI()
        
        let camera = getCamera()
        var frame = self.view.bounds
        frame.size.height -= 47.5
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        self.view.insertSubview(mapView, at: 0)
        self.mapView = mapView
        var markers = [GMSMarker]()
        if let destination = order.toAddress?.coordinate {
            markers.append(self.showMarkerAtPosition(destination, type: .destination))
        }
        markers.append(self.showMarkerAtPosition((order.fromAddress?.coordinate)!,type:.source))
        focusMapToShowMarkers(markers: markers)
        setDriver()
        showDriverLocation()
    }
    
    private func getCamera() -> GMSCameraPosition {
        guard let source = order.fromAddress?.coordinate else { return GMSCameraPosition() }
        guard let destination = order.toAddress?.coordinate else {
            return GMSCameraPosition.camera(withLatitude: source.latitude,
                                     longitude: source.longitude, zoom: 10)
        }
        let lat = source.latitude * 0.5 + destination.latitude * 0.5
        let long = source.longitude * 0.5 + destination.longitude * 0.5
        return GMSCameraPosition.camera(withLatitude: lat,
                                        longitude: long, zoom: 10)
    }
    
    private func setDriver() {
        guard let driver = order.driver else { return }
        imgDriverImageView.setImageUrl(order.driver?.url)
        phoneNumberButton.setTitle(driver.mobile, for: .normal)
        btnDriver.setTitle(driver.name, for: .normal)
    }
    func focusMapToShowMarkers(markers: [GMSMarker]) {
        guard let coordinate = markers.first?.position else { return }
        
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: coordinate,
                                                              coordinate: coordinate)
        _ = markers.map {
            bounds = bounds.includingCoordinate($0.position)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
    }
    fileprivate func showMarkerAtPosition(_ position:CLLocationCoordinate2D, type: MarkerType) -> GMSMarker{
        let marker = GMSMarker(position: position)
        switch type {
            case .source:
                marker.icon = #imageLiteral(resourceName: "trackingPin")
            case .destination:
                marker.icon = #imageLiteral(resourceName: "destinatino_icon")
            case .driverPosition:
                marker.icon = #imageLiteral(resourceName: "deliverTo")
        }
        marker.map = self.mapView
        return marker
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
    
    private func showDriverLocation() {
        let _ = order.update().then { [weak self] location -> Void in
            guard let welf = self else { return }
            let _ = welf.showMarkerAtPosition(location, type: .driverPosition)
            let _ = after(interval: 5.0).then { _ -> Void in
                guard let welf = self else { return }
                welf.showDriverLocation()
            }
        }
    }
}
