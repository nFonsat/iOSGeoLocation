//
//  GooglePlaceService.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class GooglePlaceService {
    private let baseAPI = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let key = "AIzaSyDrTvMEsK4qBvfwFbUAXuhfG5cH522Z0x4"
    
    private let parameterKey = "key"
    private let parameterLoc = "location"
    private let parameterRadius = "radius"
    private let parameterType = "types"
    
    class var SharedManager: GooglePlaceService {
        struct Singleton {
            static var instance = GooglePlaceService()
        }
        
        return Singleton.instance
    }
    
    func searchInfoLocation(location: CLLocation, radius: CLLocationDistance) -> Request {
        var parameters = [String:String]()
        
        let position = location.coordinate
        
        parameters[parameterKey] = key
        parameters[parameterLoc] = "\(position.latitude),\(position.longitude)"
        parameters[parameterRadius] = NSString(format: "%.2f", radius)
        parameters[parameterType] = "bar|restaurant|museum|park"
        
        
        var request = Alamofire.request(.GET, self.baseAPI, parameters: parameters)
        
        return request
    }
}