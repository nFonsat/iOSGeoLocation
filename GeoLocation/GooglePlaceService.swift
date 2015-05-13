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
    //MARK: Variable
    private let baseAPI     = "https://maps.googleapis.com/maps/api/place"
    private let keyProf     = "AIzaSyDrTvMEsK4qBvfwFbUAXuhfG5cH522Z0x4"
    
    //Marche pas
    private let keyNicolas  = "AIzaSyAJdCE2nI318hX8Lcd9teh5SjMZoWoNm0E"
    
    
    private let searchMode  = "/nearbysearch"
    private let detailsMode = "/details"
    private let photoMode   = "/photo"
    
    
    private let jsonMode    = "/json"
    private let xmlMode     = "/xml"
    
    
    private let parameterKey        = "key"
    private let parameterLoc        = "location"
    private let parameterRadius     = "radius"
    private let parameterType       = "types"
    
    private let parameterPhotoRef   = "photoreference"
    private let parameterMaxWidth   = "maxwidth"
    
    private let parameterPlaceID    = "placeid"
    
    //MARK: Singleton
    class var SharedManager: GooglePlaceService {
        struct Singleton {
            static var instance = GooglePlaceService()
        }
        
        return Singleton.instance
    }
    
    //MARK: Action
    func searchInfoLocation(location: CLLocation, radius: CLLocationDistance) -> Request {
        var parameters = [String:String]()
        
        let position = location.coordinate
        let url = self.baseAPI + self.searchMode + self.jsonMode
        
        parameters[parameterKey] = keyProf
        parameters[parameterLoc] = "\(position.latitude),\(position.longitude)"
        parameters[parameterRadius] = NSString(format: "%.2f", radius)
        parameters[parameterType] = "bar|restaurant|museum|park"
        
        
        var request = Alamofire.request(.GET, url, parameters: parameters)
        
        return request
    }
    
    func getDetailPlace(placeID: String) -> Request {
        var parameters = [String:String]()
        
        let url = self.baseAPI + self.detailsMode + self.jsonMode
        
        parameters[parameterKey] = keyProf
        parameters[parameterPlaceID] = placeID
        
        
        var request = Alamofire.request(.GET, url, parameters: parameters)
        
        return request
    }
    
    func getPicture(photoRef: String, maxWidth:Int) -> Request {
        var parameters = [String:String]()
        
        let url = self.baseAPI + self.photoMode
        
        
        parameters[parameterPhotoRef] = photoRef
        parameters[parameterMaxWidth] = String(maxWidth)
        parameters[parameterKey] = keyProf
        
        
        var request = Alamofire.request(.GET, url, parameters: parameters)
        
        return request
    }
}