//
//  EstimateViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/19/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLoader

class EstimateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var source:CLLocationCoordinate2D!
    var destination:CLLocationCoordinate2D!
    
    @IBOutlet weak var lblSource:UILabel!
    @IBOutlet weak var lblDestination:UILabel!
    
    @IBOutlet weak var btnBike:UIButton!
    @IBOutlet weak var btnCar:UIButton!
    @IBOutlet weak var btnTruck:UIButton!
    
    @IBOutlet weak var lblBikeServiceDescription:UILabel!
    @IBOutlet weak var lblBikeServiceName:UILabel!
    @IBOutlet weak var vBikeServiceBackground:UIView!
    
    @IBOutlet weak var lblCarServiceDescription:UILabel!
    @IBOutlet weak var lblCarServiceName:UILabel!
    @IBOutlet weak var vCarServiceBackground:UIView!
    
    @IBOutlet weak var lblTruckServiceDescription:UILabel!
    @IBOutlet weak var lblTruckServiceName:UILabel!
    @IBOutlet weak var vTruckServiceBackground:UIView!
    
    @IBOutlet weak var vDestLine:UIView!
    @IBOutlet weak var vSourceLine:UIView!
    
    @IBOutlet weak var truckServiceViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bikeServiceBackgroundViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carServiceViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vHContentViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewPic:UIImageView!
    @IBOutlet weak var txtPrice:UITextField!
    
    @IBOutlet weak var btnCashOnDelivery:UIButton!
    @IBOutlet weak var btnPayByCard:UIButton!
    @IBOutlet weak var btnConfirmButton:UIButton!
    
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    var product_pk = "1"
    var dValue = 0
    var price = 0
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func vehicleButtonTapped(_ sender:UIButton) {
        
        
        btnBike.setImage(UIImage(named: "un_bike_service"), for: UIControlState())
        btnCar.setImage(UIImage(named: "un_car_service"), for: UIControlState())
        btnTruck.setImage(UIImage(named: "un_truck_service"), for: UIControlState())
        
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "se_bike_service"), for: UIControlState())
            txtPrice.text = "AED 30"
        }else if sender.tag == 1 {
            sender.setImage(UIImage(named: "se_car_service"), for: UIControlState())
            txtPrice.text = "AED 50"
        }else if sender.tag == 2 {
            sender.setImage(UIImage(named: "se_truck_service"), for: UIControlState())
            let alert = UIAlertController(title: "FEDS", message: "A customer service representative will contact you shortly", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
                alert.dismiss(animated: true, completion: nil)
        
        })
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            txtPrice.text = ""
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "pattern")
        let color = UIColor(patternImage: img!)
        
        scrollView.backgroundColor = color
        
        assignLocationNames()
        
        imagePicker.delegate = self
        
        customizeView()
        
        txtPrice.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func customizeView() {
        //lblSource.text = "embassies area, street 11".uppercaseString
        vSourceLine.backgroundColor = GlobalConstants.SOURCE_UNDERLINE_COLOR
        //lblSource.textColor = GlobalConstants.SOURCE_UNDERLINE_COLOR
        
        //lblDestination.text = "khalidya mall".uppercaseString
        vDestLine.backgroundColor = GlobalConstants.DESTINATION_UNDERLINE_COLOR
        lblDestination.textColor = GlobalConstants.DESTINATION_UNDERLINE_COLOR
        
        //lblBikeServiceName.text = "BIKES"
        //lblBikeServiceDescription.text = "MAXIMUM SIZE: 40 CM X 40 CM X 40 CM\nMAXIMUM WEIGHT: 30KG"
        //lblBikeServiceDescription.textColor = UIColor.whiteColor()
        //vBikeServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        
        //let bikeTap = UITapGestureRecognizer(target: self, action: #selector(EstimateViewController.bikeViewTapped(_:)))
        //vBikeServiceBackground.addGestureRecognizer(bikeTap)
        
        
        
//        lblCarServiceName.text = "CARS"
//        lblCarServiceName.textColor = UIColor.whiteColor()
//        lblCarServiceDescription.textColor = UIColor.whiteColor()
//        lblCarServiceDescription.text = "MAXIMUM SIZE: 60 CM X 60 CM X 60 CM\nMAXIMUM WEIGHT: 200KG"
//        vCarServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
//        
//        let carTap = UITapGestureRecognizer(target: self, action: #selector(EstimateViewController.carViewTapped(_:)))
//        vCarServiceBackground.addGestureRecognizer(carTap)
        
        
        
//        lblTruckServiceName.text = "TRUCKS"
//        lblTruckServiceDescription.textColor = UIColor.whiteColor()
//        lblTruckServiceDescription.text = "MAXIMUM SIZE: 250 CM X 250 CM X 250 CM\nMAXIMUM WEIGHT: 500KG"
//        vTruckServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
//        
//        let truckTap = UITapGestureRecognizer(target: self, action: #selector(EstimateViewController.truckViewTapped(_:)))
//        vTruckServiceBackground.addGestureRecognizer(truckTap)
//        
//        
        
        txtPrice.text = "0.00 AED"
        txtPrice.prefixWithImageName("cash_icon")
        
        btnPayByCard.backgroundColor = GlobalConstants.THEME_COLOR
        btnCashOnDelivery.backgroundColor = GlobalConstants.THEME_COLOR
        
        
    }
    
    func bikeViewTapped(_ sender:UITapGestureRecognizer) {
        print("bike tapped")
        
        product_pk = "1"
        
        getPrice("1")
        
        vCarServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        vTruckServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        
        if let x = sender.view {
            x.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        }
        
    }
    
    func carViewTapped(_ sender:UITapGestureRecognizer) {
        print("car tapped")
        
        product_pk = "2"
        
        getPrice("2")
        
        vBikeServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        vTruckServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        
        if let x = sender.view {
            x.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        }
        
    }
    
    func truckViewTapped(_ sender:UITapGestureRecognizer) {
        print("truck tapped")
        
        product_pk = "3"
        
        
        getPrice("3")
        vCarServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        vBikeServiceBackground.backgroundColor = GlobalConstants.THEME_COLOR
        
        if let x = sender.view {
            x.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        bikeServiceBackgroundViewConstraint.constant = 100
//    
//        carServiceViewConstraint.constant = 100
//        
//        truckServiceViewConstraint.constant = 100
//        
//        vHContentViewConstraint.constant = 300 + 400
//        
//        view.layoutIfNeeded()
//        
//    }
    
    @IBAction func btnImagePickerTapped(_ sender:AnyObject) {
        
        print("update button tapped")
        
        let k = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            void in
            
            print("hello")
            
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            void in
            
            print("image tapped")
            
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            
            self.present(self.imagePicker, animated: true, completion: {
                self.imagePicker.view.tag = sender.tag
            })
            
            
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            void in
            
            print("image tapped")
            
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            
            self.present(self.imagePicker, animated: true, completion: {
                self.imagePicker.view.tag = sender.tag
            })
            
            
        })
        
        let x = UIAlertController(title: "FEDS", message: "Select Image", preferredStyle: .actionSheet)
        present(x, animated: true, completion: nil)
        
        x.addAction(k)
        x.addAction(galleryAction)
        x.addAction(cameraAction)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imgViewPic.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnConfirmRequestTapped(_ sender:AnyObject) {
        
        
        sendOrder()
        
        /*
        
        let x = self.storyboard?.instantiateViewControllerWithIdentifier("paymentvc")
        
        navigationController?.pushViewController(x!, animated: true)
 
 */
        
    }
    
    fileprivate func getPrice(_ service:String){
        
        let accessToken = UserDefaults.standard.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
        let distance = "100"
        
        let inputDict = NSDictionary(objects: [service,accessToken!,distance], forKeys: ["product_pk" as NSCopying,"accessToken" as NSCopying,"distance" as NSCopying])
        
        WebServices.getPrice(inputDict as! [AnyHashable: Any], withSuccess: {
            response in
            
        if let responseData = response as? Data {
                let newStr = String(data: responseData, encoding: String.Encoding.utf8)
                
                print(newStr)
            }
            
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: response! as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let d = jsonDict["data"] as? NSDictionary {
                    
                    
                    print(d)
                    
                    if let price = d["price"] as? NSNumber {
                        self.txtPrice.text = "\(price) AED"
                        
                        self.price = price.intValue
                    }
                    
                   
                }else{ // This is error case
                    
                    let msg = jsonDict["message"] as! String
                    self.view.showMessage(msg)
                    
                 }
                
            }catch{
                print("exception occured")
            }
            
            
            
            }, failure: {
                error in
                
                if let data = (error as! NSError).userInfo[GlobalConstants.AFNETWORKING_ERROR_KEY] as? Data {
                    
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            if let dataDict = jsonDict["data"] as? NSDictionary {
                                if let errorStr = dataDict["error"] {
                                    print(errorStr)
                                }
                            }
                        }
                    }catch {
                        print("Exception Occurred")
                    }
                }
        })
    }
    
    fileprivate func assignLocationNames() {
        
        
        let latlongSource = "\(source.latitude),\(source.longitude)"
        //let latlongSource = "37.3254392317728,22.025087140501"
        
        let latlongDest = "\(destination.latitude),\(destination.longitude)"
        
        WebServices.getplaceName(latlongSource, withSuccess: {
            
                response in
            
            if let data = response as? NSDictionary {
                
                if let arrResults = data["results"] as? NSArray {
                    
                    if let result = arrResults.firstObject as? NSDictionary {
                        let y = result["formatted_address"] as! String
                        
                        print(result)
                        
                        var strAddr = ""
                        if let addressComponents = result["address_components"] as? NSArray {
                            for component in addressComponents {
                                if let dict = component as? NSDictionary {
                                    
                                    let sname = dict["long_name"] as! String
                                    
                                    if sname != "Unnamed Road" {
                                        
                                        if strAddr == "" {
                                            strAddr = sname
                                        }else{
                                            strAddr += " - \(sname)"
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        self.lblSource.text = strAddr
                    }
                }
            }
            
           
            
            }, failure: {
                
                error in
                
                print(error)
                
        })
        
        WebServices.getplaceName(latlongDest, withSuccess: {
            
            response in
            
            if let data = response as? NSDictionary {
                
                if let arrResults = data["results"] as? NSArray {
                    
                    if let result = arrResults.firstObject as? NSDictionary {
                        let y = result["formatted_address"] as! String
                        
                        print(result)
                        
                        var strAddr = ""
                        if let addressComponents = result["address_components"] as? NSArray {
                            for component in addressComponents {
                                if let dict = component as? NSDictionary {
                                    
                                    let sname = dict["long_name"] as! String
                                    
                                    if sname != "Unnamed Road" {
                                        
                                        if strAddr == "" {
                                            strAddr = sname
                                        }else{
                                            strAddr += " - \(sname)"
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        self.lblDestination.text = strAddr
                    }
                }
            }
            
            
            
            }, failure: {
                
                error in
                
                print(error)
                
        })
        
        
    }
    
    
    fileprivate func sendOrder() {
        
        
        
        //source 
        
        let slat = "\(source.latitude)"
        let slong = "\(source.longitude)"
        let saddress = "\(lblSource.text!)"
        
        let sDict = NSDictionary(objects: ["from",saddress,slat,slong,"",""], forKeys: ["type" as NSCopying,"address" as NSCopying,"address_lat" as NSCopying,"address_ing" as NSCopying,"address_floor" as NSCopying,"address_building" as NSCopying])
        
        //destination
        
        let dlat = "\(destination.latitude)"
        let dlong = "\(destination.longitude)"
        let daddress = "\(lblDestination.text!)"
        
        let dDict = NSDictionary(objects: ["to",daddress,dlat,dlong,"",""], forKeys: ["type" as NSCopying,"address" as NSCopying,"address_lat" as NSCopying,"address_ing" as NSCopying,"address_floor" as NSCopying,"address_building" as NSCopying])
        
        //Userinfo
        
        let defaults = UserDefaults.standard
        
        let accessToken = defaults.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
        let p_pk = product_pk
        let userDeviceId = "sampleuserid"
        let dist = dValue
        let pr = "\(price)"
        let paymentType = "cash"
        let gatewaytoken = ""
        let userDict = NSDictionary(objects: [accessToken!,p_pk,userDeviceId,NSNumber(value: dist as Int),pr,"",paymentType,gatewaytoken], forKeys: ["accessToken" as NSCopying,"product_pk" as NSCopying,"user_device_id" as NSCopying,"distance" as NSCopying,"price" as NSCopying,"fileimage" as NSCopying,"paymenttype" as NSCopying,"gatewaytoken" as NSCopying])
        let addresses = NSArray(array: [sDict,dDict])
        let ipdict = NSDictionary(objects: [userDict,addresses], forKeys: ["userinfo" as NSCopying,"orderaddress" as NSCopying])
        SwiftLoader.show(animated: true)
        WebServices.submitOrder(ipdict as! [AnyHashable: Any], withSuccess: {
                response in
            SwiftLoader.hide()
            if let rdata = response as? Data {
                do{
                    let jsonDict = try JSONSerialization.jsonObject(with: response! as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let d = jsonDict["data"] as? NSDictionary {
                        if let tid = d["order_tokenid"] as? NSNumber {
                            let message = "Your order reference id \(tid)"
                            self.view.showMessage(message)
                        }
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }catch{ }
            }
            }, failure: { error in
                SwiftLoader.hide()
                self.navigationController?.popToRootViewController(animated: true) 
        })
    }
    
    fileprivate func getDistance() {
        let so = "\(source.latitude),\(source.longitude)"
        let de = "\(destination.latitude),\(destination.longitude)"
        WebServices.getDistance(so, destination: de, withSuccess: {
            response in
            if let responseDict = response as? NSDictionary {
                if let rows = responseDict["rows"] as? [NSDictionary] {
                    print(rows.count)
                    for dict in rows {
                        if let elementsArray = dict["elements"] as? [NSDictionary]{
                            for elementDict in elementsArray {
                                print(elementDict)
                                if let distanceDict = elementDict["distance"] as? NSDictionary {
                                    if let text = distanceDict["text"] as? String {
                                    }
                                    if let distanceVal = distanceDict["value"] as? NSNumber {
                                        print("distance is \(distanceVal)")
                                        self.dValue = distanceVal.intValue
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            }, failure: { error in
        })
    }
    @IBAction func cashOnDeliveryTapped(_ sender:UIButton) {
        sender.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        btnPayByCard.backgroundColor = GlobalConstants.THEME_COLOR
    }
    @IBAction func payByCard(_ sender:UIButton) {
        sender.backgroundColor = GlobalConstants.THEME_COLOR_GREY
        btnCashOnDelivery.backgroundColor = GlobalConstants.THEME_COLOR
    }
}
