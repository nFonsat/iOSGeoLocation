//
//  PlaceTableViewController.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class PlaceTableViewController: UITableViewController {
    var location:Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var place = GooglePlaceService.SharedManager
        var request = place.searchInfoLocation(
            CLLocation(latitude: Double(location.latitude), longitude: Double(location.longitude)),
            radius:  Double(location.radius))
        
        request.responseJSON { (request, response, json, error) in
            println(json)
            
            let json = JSON(json!)
    
        }
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
