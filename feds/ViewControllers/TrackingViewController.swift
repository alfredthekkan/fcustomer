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
    
    @IBOutlet weak var imgDriverImageView:UIImageView!
    
    @IBOutlet weak var btnDriver:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 24.00,
                                                          longitude: 54.00, zoom: 20)
        
        
        var frame = self.view.bounds
        frame.size.height -= 47.5
        
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.isMyLocationEnabled = true
        
        
        
        
        

        //self.view.addSubview(mapView)
        //self.view = mapView
        self.view.insertSubview(mapView, at: 0)
        
        self.mapView = mapView
        
        let position = CLLocationCoordinate2DMake(24, 54)
        
        let p = CLLocationCoordinate2DMake(24.4, 54.4)
        
        self.showMarkerAtPosition(position,isDriver:false)
        self.showMarkerAtPosition(p, isDriver: true)
        
        imgDriverImageView.image = UIImage(named: "driver_placeholder")

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func customizeUI() {
        imgDriverImageView.makeRoundCorder()
    }
    
    @IBAction func btnCallTapped(_ sender:AnyObject) {
        
        if order.mobile != "" {
            
            let y = "tel://\(order.mobile)"
            
            let url = URL(string: y)
            
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }else{
                self.view.showMessage("Cannot make calls to this number")
            }
            
        }
        
        
        
    }

}
