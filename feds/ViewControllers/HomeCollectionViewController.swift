//
//  HomeCollectionViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/15/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import SwiftLoader

struct MenuItem {
    var imageName:String
    var hightlightedImageName:String
}

class HomeCollectionViewController: UIViewController {
    
    let BLUR_IMAGE_TAG = 111
    
    var arrMenu = [MenuItem]()
    
    weak var alertView:AlertCustomView!
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let m1 = MenuItem(imageName: "courier", hightlightedImageName: "courier_selected")
        let m2 = MenuItem(imageName: "contactusunselected", hightlightedImageName: "contactusselected")
        let m3 = MenuItem(imageName: "pharmacy", hightlightedImageName: "pharmacy_selected")
        let m4 = MenuItem(imageName: "pr", hightlightedImageName: "pr_selected")
        let m5 = MenuItem(imageName: "supermarket", hightlightedImageName: "supermarket_selected")
        let m6 = MenuItem(imageName: "trackorder", hightlightedImageName: "trackorder_selected")
        
        arrMenu = [m1,m6,m5,m3,m4,m2]
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
        
        let im = UIImageView(frame: self.view.bounds)
        collectionView.backgroundView = im
        im.image = UIImage(named: "pattern")
        im.contentMode = .scaleAspectFill
    
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:GlobalConstants.THEME_COLOR]
       
        title = "FEDS"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let x:CGFloat = 247.0/255.0
        
        navigationController?.navigationBar.tintColor = UIColor.blue
        
        navigationController?.navigationBar.tintColor = GlobalConstants.THEME_COLOR
        
        
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func configureLayout() {
        
        
        let MINIMUM_INTERCELL_SPACING:CGFloat = 10
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width - 20 - MINIMUM_INTERCELL_SPACING)/2
        
        print(width)
        let height = width * 369 / 342
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = MINIMUM_INTERCELL_SPACING
        layout.minimumLineSpacing = MINIMUM_INTERCELL_SPACING
        collectionView.collectionViewLayout = layout
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = view.backgroundColor
    }
    
    
    @IBAction func logoutTapped(_ sender:AnyObject) {
        
    
        if let at = UserDefaults.standard.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN) {
            
            UserDefaults.standard.removeObject(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
            
            let inputDict = NSDictionary(objects:[at], forKeys: [GlobalConstants.KEY_ACCESS_TOKEN as NSCopying])
            SwiftLoader.show(animated: true)
            
            WebServices.logout(inputDict as! [AnyHashable: Any], withSuccess: { response in
                
                SwiftLoader.hide()
                
                let x = self.storyboard?.instantiateInitialViewController()
                self.view.window?.rootViewController = x
                
                
                
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
                        }catch { }
                    }
                    SwiftLoader.hide()
            })
            
        }
    }
    func showBlur() {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        // 3
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        // 4
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        let lightImage = screenshot?.applyBlur(withRadius: 5.0, tintColor: UIColor.clear, saturationDeltaFactor: 0.5, maskImage: nil)
        
    
        
        UIGraphicsEndImageContext()
        
        let iv = UIImageView(image: lightImage)
        
        iv.isUserInteractionEnabled = true
        
        
        iv.tag = BLUR_IMAGE_TAG
        
        let tapg = UITapGestureRecognizer(target: self, action: #selector(HomeCollectionViewController.blurTapped(_:)))
        iv.addGestureRecognizer(tapg)
        
        iv.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            iv.alpha = 1.0
        })
        
        
        view.insertSubview(iv, at: 1)
        
        
        
    }
    
    func blurTapped(_ sender:UITapGestureRecognizer) -> Void {
        let iv = sender.view
        iv?.removeFromSuperview()
        
        if self.alertView != nil {
            self.alertView.removeFromSuperview()
        }
    }


}




extension HomeCollectionViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let iv = cell.viewWithTag(111) as? UIImageView {
            let menuItem = arrMenu[indexPath.row]
            
            iv.image = UIImage(named: menuItem.imageName)
            iv.highlightedImage = UIImage(named: menuItem.hightlightedImageName)
            
            
        }
        
        return cell
       
    }
    
}

extension HomeCollectionViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function)
        
        let item = arrMenu[indexPath.row]
        
        print(item.imageName)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
       
        var ips = Set<Int>()
        ips.insert(4)
        ips.insert(2)
        ips.insert(3)
        
        if ips.contains(indexPath.row) {
            
            showBlur()
            
        }
        
        if ips.contains(indexPath.row) {
            
            
            
            
            let width = UIScreen.main.bounds.width
            let padding:CGFloat = 20
            
            
            
            let alertView = AlertCustomView(frame: CGRect(x: 0,y: 0,width: width - 2 * padding,height: 200))
            
            
            alertView.tag = indexPath.row
            
            alertView.delegate = self
            
            alertView.center = view.center
            
            
            alertView.alpha = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                
                alertView.alpha = 1.0
            })
            
            view.addSubview(alertView)
            
            
            self.alertView = alertView
            
            
        }
        
        if indexPath.row == 0 {
            
            let x = self.storyboard?.instantiateViewController(withIdentifier: "FromPointVC")
            navigationController?.pushViewController(x!, animated: true)
            
        }else if indexPath.row == 1 {
            
            let x = self.storyboard?.instantiateViewController(withIdentifier: "courierlist")
            navigationController?.pushViewController(x!, animated: true)
            
        }else if indexPath.row == 5 {
            let v = storyboard?.instantiateViewController(withIdentifier: "contact")
            navigationController?.pushViewController(v!, animated: true)
        }
        
    }
    
    
}


extension HomeCollectionViewController:AlertCustomViewDelegate {
    
    func alertResponseSelected(_ status:Bool) {
        
        if self.alertView != nil {
            
            self.alertView.removeFromSuperview()
            
            
            
            if status {
                let tag = alertView.tag
                var serviceName = ""
                
                switch tag {
                case 2:
                    serviceName = "Supermarket Service"
                case 3:
                    serviceName = "Pharmacy Service"
                case 4:
                    serviceName = "Public Relations Services"
                default:
                    print("Unknown Serivice")
                }
                
                let defaults = UserDefaults.standard
                
                let accessToken = defaults.string(forKey: GlobalConstants.KEY_ACCESS_TOKEN)
                
                let inputDict = NSDictionary(objects: [accessToken!,serviceName], forKeys: ["accessToken" as NSCopying,"servicename" as NSCopying])
                
                SwiftLoader.show(title: "Loading", animated: true)
                
                WebServices.requestCall(inputDict as! [AnyHashable: Any], withSuccess: {
                    response in
                    
                    SwiftLoader.hide()
                    
                    if let responseData = response as? Data {
                        let newStr = String(data: responseData, encoding: String.Encoding.utf8)
                        
                        print(newStr)
                    }
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response! as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        if let d = jsonDict["data"] as? NSDictionary {
                            
                            if let msg = d["message"] as? String {
                                self.view.showMessage(msg)
                            }
                            
                            
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
                            }catch { }
                        }
                        SwiftLoader.hide()
                })
            }
        }
        
        
        for view in self.view.subviews {
            if let iv = view as? UIImageView {
                if iv.tag == BLUR_IMAGE_TAG {
                    iv.removeFromSuperview()
                }
            }
        }
    }
    
}


