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
import PromiseKit

class LocationSelectViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var mapTypeSegmentButton: UISegmentedControl!
    @IBOutlet weak var btnPickUpFromHere:UIButton!
    @IBOutlet weak var markDeliveryButton:UIButton!
    
    var placePicker: GMSPlacePicker?
    var mapView:GMSMapView!
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PICKUP FROM"
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SelectFromLocationViewController.onLaunchClicked(_:)))
        navigationItem.rightBarButtonItem = searchBtn
        _addMap()
        _customizeView()
    }
    
    //MARK: - User Interaction
    @IBAction func mapTypeSegmentButtonValueChanged(_ sender: UISegmentedControl) {
        mapView.mapType = [kGMSTypeSatellite, kGMSTypeNormal][sender.selectedSegmentIndex]
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func onLaunchClicked(_ sender: AnyObject) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
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

            } else {
            
            }
        } as! GMSPlaceResultCallback)
    }
    
    // Pan recognizer
    @IBAction func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Mark delivery
    @IBAction func markDeliveryTapped(_ sender:UIButton) {
        var p = btnPickUpFromHere.center
        p.y = p.y + btnPickUpFromHere.frame.height/2
        let mapviewPoint = view.convert(p, to: mapView)
        let coord = mapView.projection.coordinate(for: mapviewPoint)
        let x = self.storyboard?.instantiateViewController(withIdentifier: "ToPointVC") as! LocationSelectViewController
        x.source = coord
        navigationController?.pushViewController(x, animated: true)
    }
    
    //MARK: - Private Methods
    private func _addMap(){
        var coordingate :CLLocationCoordinate2D = CLLocationCoordinate2D.init()
        let _ = firstly(execute: {
            CLLocationManager.promise()
        }).then(execute: { location in
            coordingate = location.coordinate
        }).always {
            let camera = GMSCameraPosition.camera(withLatitude: coordingate.latitude,
                                                  longitude: coordingate.longitude, zoom: 20)
            let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
            mapView.isMyLocationEnabled = true
            mapView.mapType = kGMSTypeSatellite
            mapView.delegate = self
            self.view.insertSubview(mapView, at: 0)
            self.mapView = mapView
        }
    }
    private func _customizeView() {
        mapTypeSegmentButton.tintColor = GlobalConstants.THEME_COLOR
        navigationController?.navigationBar.tintColor = GlobalConstants.THEME_COLOR
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:GlobalConstants.THEME_COLOR]
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
}
