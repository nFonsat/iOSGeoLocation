//
//  AddLocationViewController.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    //MARK: Variable
    var locationManager:CLLocationManager!
    var locationFound:Bool!
    
    var currentAnnotation = MKPointAnnotation()
    var currentOverlay = MKCircle()
    var currentPositionPinned:CLLocationCoordinate2D!
    var annotationAdded = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    @IBOutlet weak var labelRayon: UILabel!
    
    //MARK: Application
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        initLocationManager()
        checkStatePing()
    }
    
    //MARK: Action
    
    @IBAction func CancelAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveLocationAction(sender: UIBarButtonItem) {
        if annotationAdded {
            let alert = UIAlertController(title: "Add location",
                message: "Place name",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let saveAction = UIAlertAction(title: "Save",
                style: UIAlertActionStyle.Default)
                { (action: UIAlertAction!) -> Void in
                    let textField = alert.textFields![0] as UITextField
                    
                    if let location = LocationManager.SharedManager.createLocationWithName(textField.text) {
                        location.longitude = self.currentAnnotation.coordinate.longitude
                        location.latitude = self.currentAnnotation.coordinate.latitude
                        location.radius = self.currentOverlay.radius
                        
                        location.managedObjectContext?.save(nil)
                    }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addTextFieldWithConfigurationHandler(nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            var geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(
                CLLocation(latitude: self.currentAnnotation.coordinate.latitude, longitude: self.currentAnnotation.coordinate.longitude),
                completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
                    let placemark = placemarks[0] as CLPlacemark
                    let addressDictionary = placemark.addressDictionary as NSDictionary
                    
                    let valueOptional = addressDictionary.valueForKey("Name") as String?
                    
                    if let value = valueOptional {
                        (alert.textFields![0] as UITextField).text = value
                    }
                    
                    self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    //MARK: MKMapView
    
    func checkStatePing() {
        if(annotationAdded){
            saveItem.enabled = true
            slider.hidden = false
            labelRayon.hidden = false
        } else {
            saveItem.enabled = false
            slider.hidden = true
            labelRayon.hidden = true
        }
    }
    @IBAction func onTapMapView(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(mapView)
        currentPositionPinned = mapView.convertPoint(point, toCoordinateFromView: mapView)
        
        self.createAnnotationWithPosition(currentPositionPinned)
    }
    
    func createAnnotationWithPosition(position: CLLocationCoordinate2D) {
        if annotationAdded {
            mapView.removeAnnotation(currentAnnotation)
            mapView.removeOverlay(currentOverlay)
        }
        
        annotationAdded = true
        
        currentAnnotation.setCoordinate(position)
        mapView.addAnnotation(currentAnnotation)
        
        mapView.delegate = self
        currentOverlay = MKCircle(centerCoordinate: position, radius: 250 as CLLocationDistance)
        mapView.addOverlay(currentOverlay)
        
        labelRayon.text = "Search radius : 250m"
        slider.value = 250
        
        checkStatePing()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blueColor()
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        var location = userLocation.location.coordinate
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.centerCoordinate = location
    }
    
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!) {
        println("Error location : \(error.localizedDescription)")
    }
    
    //MARK: Slider
    
    @IBAction func changeRadius(sender: UISlider) {
        if annotationAdded {
            let value = sender.value
            
            mapView.removeOverlay(currentOverlay)
            
            mapView.delegate = self
            currentOverlay = MKCircle(centerCoordinate: currentPositionPinned, radius: Double(value))
            mapView.addOverlay(currentOverlay)
            
            labelRayon.text = "Search radius : \(Int(value))m"
        }
    }
    
    //MARK: CLLocationManager
    
    func initLocationManager() {
        locationFound = false;
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var locationStatus = ""
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
        }
        
        println("\(locationStatus)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if !locationFound {
            locationFound = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var location = locationObj.coordinate
            
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}