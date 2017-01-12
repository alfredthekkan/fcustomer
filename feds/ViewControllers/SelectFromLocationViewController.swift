//
//  SelectFromLocationViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/16/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

import GoogleMaps

import CoreLocation

class SelectFromLocationViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    var placePicker: GMSPlacePicker?
    var mapView:GMSMapView!
    
    var manager:CLLocationManager?
    
    // Instantiate a pair of UILabels in Interface Builder

    
    @IBOutlet weak var mapTypeSegmentButton: UISegmentedControl!
    @IBOutlet weak var btnPickUpFromHere:UIButton!

    
    @IBOutlet weak var markDeliveryButton:UIButton!
    
    
    
    @IBAction func mapTypeSegmentButtonValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = kGMSTypeSatellite
        }else{
            mapView.mapType = kGMSTypeNormal
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       mapTypeSegmentButton.tintColor = GlobalConstants.THEME_COLOR
        
        self.title = "PICKUP FROM"
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SelectFromLocationViewController.onLaunchClicked(_:)))
        navigationItem.rightBarButtonItem = searchBtn

        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 24.00,
                                                          longitude: 54.00, zoom: 20)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
         mapView.mapType = kGMSTypeSatellite
        
        
        mapView.delegate = self
        //self.view.addSubview(mapView)
        //self.view = mapView
        self.view.insertSubview(mapView, at: 0)
        
        self.mapView = mapView
        
        customizeView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startStandardUpdates()
        
    }
    
    func startStandardUpdates() {
        
        if nil == manager {
            
            manager = CLLocationManager()
            manager?.delegate = self
            manager?.activityType = .automotiveNavigation
            
        }
        
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.distanceFilter = 0.01
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            manager?.requestAlwaysAuthorization()
        }else{
            manager?.startUpdatingLocation()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func onLaunchClicked(_ sender: AnyObject) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Add a UIButton in Interface Builder to call this function
    @IBAction func pickPlace(_ sender: UIButton) {
        let center = CLLocationCoordinate2DMake(37.788204, -122.411937)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlace(callback: { (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                
                
                //self.nameLabel.text = place.name
                //self.addressLabel.text = place.formattedAddress!.componentsSeparatedByString(", ").joinWithSeparator("\n")
            } else {
                //self.nameLabel.text = "No place selected"
                //self.addressLabel.text = ""
            }
        } as! GMSPlaceResultCallback)
    }
    
    // MARK: - Private Methods
    
    fileprivate func customizeView() {
        
        
        
        navigationController?.navigationBar.tintColor = GlobalConstants.THEME_COLOR
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:GlobalConstants.THEME_COLOR]
        
        
        
    }
    
    @IBAction func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func markDeliveryTapped(_ sender:UIButton) {
        
        var p = btnPickUpFromHere.center
        p.y = p.y + btnPickUpFromHere.frame.height/2
        
        let mapviewPoint = view.convert(p, to: mapView)
        
        let coord = mapView.projection.coordinate(for: mapviewPoint)
        
        let x = self.storyboard?.instantiateViewController(withIdentifier: "ToPointVC") as! SelectToLocationViewController
        
        x.source = coord
        
        navigationController?.pushViewController(x, animated: true)
 
    }
}
extension SelectFromLocationViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        self.dismiss(animated: true, completion: nil)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let eventDate = location?.timestamp
        let howRecent = eventDate?.timeIntervalSinceNow
        
        if abs(howRecent!) < 15 {
            var x = mapView.projection.point(for: (location?.coordinate)!)
            x = mapView.convert(x, to: view)
            x.y -= btnPickUpFromHere.frame.height/2
            btnPickUpFromHere.center = x
            let cameraUpdate = GMSCameraUpdate.setTarget((location?.coordinate)!, zoom: 20)
            self.mapView.animate(with: cameraUpdate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}
