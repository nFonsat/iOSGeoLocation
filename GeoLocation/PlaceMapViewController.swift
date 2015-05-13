//
//  PlaceMapViewController.swift
//  GeoLocation
//
//  Created by iem on 11/05/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceMapViewController: UIViewController, MKMapViewDelegate {
    var places:[Place]!
    var annotations:[PlaceAnnotation]?
    
    var positionLocation:CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        addPlaceIMapView()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateAnnotation()
    }
    
    //MARK: Helper UI
    func addPlaceIMapView() {
        //println(places.count)
        for place in places {
            createAnnotationWithPlace(place)
        }
        zoomAllAnnotation()
    }
    
    func zoomAllAnnotation() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(positionLocation, 5000, 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.centerCoordinate = positionLocation
    }
    
    func createAnnotationWithPlace(place: Place) {
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.latitude), longitude: CLLocationDegrees(place.longitude))
        let placeAnnotation = PlaceAnnotation(title: place.name, category: place.cat, note: place.note, coordinate: position)
        
        mapView.addAnnotation(placeAnnotation)
        
        if self.annotations == nil {
            self.annotations = [PlaceAnnotation]()
        }
        
        self.annotations?.append(placeAnnotation)
    }
    
    func removeAllAnnotation() {
        if let placeAnnotationList = self.annotations {
            for annotation in placeAnnotationList {
                mapView.removeAnnotation(annotation)
            }
            self.annotations = [PlaceAnnotation]()
        }
    }
    
    func updateAnnotation() {
        removeAllAnnotation()
        addPlaceIMapView()
    }
    
    func getPLaceWithName(name:String) -> Place?{
        var placeToReturn:Place?
        
        for place in places {
            if place.name == name {
                placeToReturn = place
                break
            }
        }
        
        return placeToReturn
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? PlaceAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.pinColor = annotation.pinColor()
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
                view.pinColor = annotation.pinColor()
            }
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let annotation = view.annotation as PlaceAnnotation
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var destination = storyboard.instantiateViewControllerWithIdentifier("placeDetail") as PlaceDetailViewController
        destination.place = getPLaceWithName(annotation.getNameLocation())
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
}