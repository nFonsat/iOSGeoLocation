//
//  PlaceTableViewController.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UITableViewController {
    var location:Location!
    
    let categoriesPlaceText = ["Restaurants","Bars","Museums","Parks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesPlaceText.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("placeCell") as UITableViewCell
        
        cell.textLabel.text = categoriesPlaceText[indexPath.row]
        
        cell.imageView.image = UIImage(named: "restaurant")!
        
        
        return cell
    }
}
