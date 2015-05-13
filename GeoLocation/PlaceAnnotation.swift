//
//  PlaceAnnotation.swift
//  GeoLocation
//
//  Created by iem on 12/05/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    let discipline: String
    let note: NSNumber?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, category: String, note:NSNumber?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = title
        self.discipline = category
        self.coordinate = coordinate
        self.note = note
        
        super.init()
    }
    
    func getNameLocation() -> String {
        return locationName
    }
    
    func pinColor() -> MKPinAnnotationColor  {
        if note == 0 {
            return MKPinAnnotationColor.Red
        } else {
            return MKPinAnnotationColor.Purple
        }
    }
}
