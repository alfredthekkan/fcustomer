//
//  HomeViewController.swift
//  Fedex
//
//  Created by TMC-4 on 6/9/16.
//  Copyright © 2016 AlfredThekkan. All rights reserved.
//

import UIKit

struct CellElement {
    var serviceName:String
    var imageName:String
}

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let CELL_IMAGE_VIEW_TAG = 111
    let CELL_LABEL_TAG = 222
    let CELL_SPACING:CGFloat = 10.0
    
    
    var dataArray:[CellElement]!
    // MARK: - Table View Data Source
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let c1 = CellElement(serviceName: "Courier Services", imageName: "courier")
        let c2 = CellElement(serviceName: "Supermarket Services", imageName: "supermarket")
        let c3 = CellElement(serviceName: "Pharmacy Services", imageName: "pharmacy")
        let c4 = CellElement(serviceName: "Public Relations Services", imageName: "pr")
        
        dataArray = [c1,c2,c3,c4]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = GlobalConstants.THEME_COLOR
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.backgroundColor = GlobalConstants.THEME_COLOR
        
        let cellElement = dataArray[indexPath.section]
        
        if let img = cell?.viewWithTag(CELL_IMAGE_VIEW_TAG) as? UIImageView {
            img.image = UIImage(named: cellElement.imageName)
        }
        if let lbl = cell?.viewWithTag(CELL_LABEL_TAG) as? UILabel {
                lbl.text = cellElement.serviceName.uppercased()
            lbl.textColor = UIColor.white
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CELL_SPACING
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.height - 5 * CELL_SPACING)/4
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutTapped(_ sender:AnyObject) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    


}
