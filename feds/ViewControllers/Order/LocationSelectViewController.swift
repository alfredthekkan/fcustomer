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
    @IBOutlet weak var selectLocationButton:UIButton!
    @IBOutlet weak var currentLocationButton:UIButton!
    @IBOutlet weak var homeLocationButton:UIButton!
    @IBOutlet weak var workLocationButton:UIButton!
    var type : LocationType = .source
    
    var placePicker: GMSPlacePicker?
    var mapView:GMSMapView!
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _addMap()
        _customizeView()
        _addBarbuttons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .source {
            navigationItem.title = "PICKUP FROM"
        }else {
            navigationItem.title = "DELIVER TO"
        }
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
    
    @IBAction func skipTapped(_ sender: Any) {
        if let id = alternateStoryBoardIdentifier {
            performSegue(withIdentifier: id, sender: nil)
        }
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
    @IBAction func locationSelectTapped(_ sender:UIButton) {
        var p = currentLocationButton.center
        p.y = p.y + currentLocationButton.frame.height/2
        let mapviewPoint = view.convert(p, to: mapView)
        let coord = mapView.projection.coordinate(for: mapviewPoint)
        
        let address = DeliveryAddress(type: type)
        address.coordinate = coord
        proceed(address)
    }
    
    
    @IBAction func chooseSavedLocationTapped(_ sender:UIButton) {
        let alert = UIAlertController(title: "Choose a location", message: nil, preferredStyle: .actionSheet)
        let work = UIAlertAction(title: "Work", style: .default) { _ in
            guard let address = UserDefaults.standard.object(forKey: AddressViewController.AddessType.work.rawValue) as? [String: Any] else {
                self.show(message: "Work Address Not Set")
                return
            }
            guard let dlAddress = DeliveryAddress(address: address, type: self.type) else {
                self.show(message: "Work Address Not Set")
                return
            }
            self.proceed(dlAddress)
        }
        let home = UIAlertAction(title: "Home", style: .default) { _ in
            guard let address = UserDefaults.standard.object(forKey: AddressViewController.AddessType.work.rawValue) as? [String: Any] else {
                self.show(message: "Home Address Not Set")
                return
            }
            guard let dlAddress = DeliveryAddress(address: address, type: self.type) else {
                self.show(message: "Home Address Not Set")
                return
            }
            self.proceed(dlAddress)
        }
        alert.addAction(work)
        alert.addAction(home)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func workLocationTapped(_ sender:UIButton) {
        
    }
    
    private func proceed(_ address: DeliveryAddress) {
        if type == .source {
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "ToPointVC") as! LocationSelectViewController
            viewcontroller.type = .destination
            Order.current?.fromAddress = address
            navigationController?.pushViewController(viewcontroller, animated: true)
        }else{
            Order.current?.toAddress = address
            if let identifier = alternateStoryBoardIdentifier {
                performSegue(withIdentifier: identifier, sender: nil)
            }
        }
    }
    
    //MARK: - Private Methods
    private func _addBarbuttons() {
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(LocationSelectViewController.homeTapped))
        navigationItem.rightBarButtonItem = homeButton
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(LocationSelectViewController.onLaunchClicked(_:)))
        navigationItem.rightBarButtonItem = searchBtn
        navigationItem.rightBarButtonItems = [homeButton, searchBtn]
    }
    func homeTapped() {
        performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    private func _addMap(){
        var coordingate :CLLocationCoordinate2D = CLLocationCoordinate2D.init()
        let _ = firstly(execute: {
            CLLocationManager.promise()
        }).then(execute: { location in
            coordingate = location.coordinate
        }).always {
            let camera = GMSCameraPosition.camera(withLatitude: coordingate.latitude,
                                                  longitude: coordingate.longitude, zoom: 15)
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

extension LocationSelectViewController :GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true) {
            self.mapView.animate(toLocation: place.coordinate)
        }
    }
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.show(error: error)
        
    }
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

