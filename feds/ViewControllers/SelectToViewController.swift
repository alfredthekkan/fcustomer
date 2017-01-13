//
//  SelectFromLocationViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/16/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

import GoogleMaps

class SelectToLocationViewController: UIViewController,GMSMapViewDelegate {
    
    var placePicker         : GMSPlacePicker?
    var mapView             :GMSMapView!
    var source              :CLLocationCoordinate2D!
    
    @IBOutlet weak var btnDeliverTo:UIButton!
    @IBOutlet weak var selectVehicle:UIButton!
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchButton()
        addmap()
        customizeView()
    }
    
    // MARK: - Private Methods
    private func customizeView() {
        self.navigationItem.title = "DELIVER TO"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:GlobalConstants.THEME_COLOR]
        navigationController?.navigationBar.tintColor = GlobalConstants.THEME_COLOR
    }
    
    private func addSearchButton() {
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SelectToLocationViewController.onLaunchClicked(_:)))
        navigationItem.rightBarButtonItem = searchBtn
    }
    
    private func addmap() {
        let camera = GMSCameraPosition.camera(withLatitude: 24.00,
                                              longitude: 54.00, zoom: 20)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view.insertSubview(mapView, at: 0)
        self.mapView = mapView
    }
    
    //MARK: - User Interaction
    @IBAction func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func markDeliveryTapped(_ sender:UIButton) {
        let x = self.storyboard?.instantiateViewController(withIdentifier: "ToPointVC")
        navigationController?.pushViewController(x!, animated: true)
    }
    
    @IBAction func selectVehicleTapped(_ sender:AnyObject) {
         var p = btnDeliverTo.center
         p.y = p.y + btnDeliverTo.frame.height/2
         let mapviewPoint = view.convert(p, to: mapView)
         let coord = mapView.projection.coordinate(for: mapviewPoint)
        let x = self.storyboard?.instantiateViewController(withIdentifier: "selectvehicle") as! EstimateViewController
        x.source = source
        x.destination = coord
        navigationController?.pushViewController(x, animated: true)
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
            } else {}
            } as! GMSPlaceResultCallback)
    }
    @IBAction func mapTypeSegmentButtonValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = kGMSTypeSatellite
        }else{
            mapView.mapType = kGMSTypeNormal
        }
    }
}

extension SelectToLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController!, didAutocompleteWith place: GMSPlace!) {
        self.dismiss(animated: true, completion: {
            let cameraUpdate = GMSCameraUpdate.setTarget(place.coordinate, zoom: 20)
            self.mapView.animate(with: cameraUpdate)
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: Error!) {
        // TODO: handle the error.
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController!) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
