//
//  PlaceTableViewController.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceTableViewController: UITableViewController {
    var location:Location!
    
    let categories = ["restaurant", "bar", "museum", "park"]
    let categoriesPlaceText = ["Restaurants","Bars","Museums","Parks"]
    let categoriesPlaceIcon = ["restaurant","beer","museum","park"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Helper UI
    
    func getPlacesWithCategory(categoryName:String) -> [Place]{
        var places = [Place]()
        
        for onePlace in location.places {
            let place = onePlace as Place
            if place.cat == categoryName {
                //println("\(place.name) : \(place.cat)")
                places.append(place)
            }
        }
        
        return places
    }

    //MARK: Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesPlaceText.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("placeCell") as UITableViewCell
        
        cell.textLabel.text = categoriesPlaceText[indexPath.row]
        cell.imageView.image = UIImage(named: categoriesPlaceIcon[indexPath.row])!
        
        return cell
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "placeMapSegue" {
            let placeMap = segue.destinationViewController as PlaceMapViewController

            let indexPath  = tableView.indexPathForSelectedRow()!
            let categoryName = categories[indexPath.row]
            let places = getPlacesWithCategory(categoryName)
            
            placeMap.places = places
            placeMap.positionLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
            placeMap.title = categoriesPlaceText[indexPath.row]
        }
    }
}
