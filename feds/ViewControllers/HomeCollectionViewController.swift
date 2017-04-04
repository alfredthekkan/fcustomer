//
//  HomeCollectionViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/15/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeCollectionViewController: UIViewController {
    private let BLUR_IMAGE_TAG = 111
    
    // Outlets
    @IBOutlet weak var collectionView:UICollectionView!
    weak var alertView:AlertCustomView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        let im = UIImageView(frame: self.view.bounds)
        collectionView.backgroundView = im
        im.image = UIImage(named: "pattern")
        im.contentMode = .scaleAspectFill
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:GlobalConstants.THEME_COLOR]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "FEDS"
        navigationController?.navigationBar.tintColor = GlobalConstants.THEME_COLOR
    }

    // MARK: - Private Methods
    private func configureLayout() {
        let MINIMUM_INTERCELL_SPACING:CGFloat = 10
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 20 - MINIMUM_INTERCELL_SPACING)/2
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
    
    //MARK: - User Interaction
    @IBAction func logoutTapped(_ sender:AnyObject) {
        User.current.logout().response(completionHandler: {[weak self] response in
            Session.delete()
            FBSDKLoginManager().logOut()
            let loginVC = self?.storyboard?.instantiateInitialViewController()
            self?.view.window?.rootViewController = loginVC
        })
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    //MARK: - Private Methods
    fileprivate func _showBlur() {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
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
    
    fileprivate func _showAlert(_ item :RequestItem) {
        let width = UIScreen.main.bounds.width
        let padding:CGFloat = 20
        let alertView = AlertCustomView(frame: CGRect(x: 0,y: 0,width: width - 2 * padding,height: 200))
        alertView.onApprove = {
            item.request().response(completionHandler: { [weak self] response in
                if let error = response.error {
                    print("Error: \(error.localizedDescription)")
                }
                self?.show(title: item.type.rawValue, message: "Our Agent will contact you shortly")
                print("Successfully Requested")
            })
        }
        alertView.center = view.center
        alertView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            alertView.alpha = 1.0
        })
        view.addSubview(alertView)
        self.alertView = alertView
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
        return MenuItem.allitems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let iv = cell.viewWithTag(111) as? UIImageView {
            let menuItem = MenuItem.allitems()[indexPath.row]
            iv.image = UIImage(named: menuItem.imageName!)
            iv.highlightedImage = UIImage(named: menuItem.hightlightedImageName!)
        }
        return cell
    }
}

extension HomeCollectionViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = MenuItem.allitems()[indexPath.row]
        if item is RequestItem {
            _showAlert(item as! RequestItem)
        }
        switch item.type {
        case .newOrder:
            performSegue(withIdentifier: "newOrder", sender: nil)
        case .trackOrder:
            performSegue(withIdentifier: "courierList", sender: nil)
        case .contact:
            performSegue(withIdentifier: "contactSegue", sender: nil)
        default:
            print("unknown case")
        }
    }
}
