//
//  LocationManager.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import CoreData

class LocationManager {
    
    lazy var coreData:CoreDataManager? = CoreDataManager.SharedManager
    
    var contextObject:NSManagedObjectContext? {
        get {
            if let context = coreData?.managedObjectContext {
                return context
            }
            return nil
        }
    }
    
    class var SharedManager: LocationManager {
        struct Singleton {
            static let instance = LocationManager()
        }
        
        Singleton.instance.coreData = CoreDataManager.SharedManager
        return Singleton.instance
    }
    
    func fetchLocation(predicate : NSPredicate) -> Location? {
        
        if let tasks = fetchLocations(predicate, sortDescriptors: nil) {
            return tasks[0]
        }
        
        return nil
    }
    
    func fetchLocations(predicate : NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [Location]? {
        let fetchRequest = NSFetchRequest(entityName: "Location")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        var error: NSError? = nil
        
        let results = contextObject!.executeFetchRequest(fetchRequest, error: &error) as [Location]
        
        if results.count > 0 {
            return results
        }
        
        if error != nil {
            println(" Could not fetch data : \(error), \(error?.description) ")
        }
        
        return nil
    }
    
    func getLocations () -> [Location] {
        var locations = [Location]()
        
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let results = fetchLocations(nil, sortDescriptors: sortDescriptors) {
            locations = results
        }
        
        return locations
    }
    
    func createLocationWithName(name : String?) -> Location? {
        if let nameValue = name {
            let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: contextObject!)
            
            let location = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: contextObject) as Location
            
            location.name = nameValue
            
            var error: NSError? = nil
            contextObject!.save(&error)
            
            if error != nil {
                println(" Could not save context : \(error), \(error?.description) ")
            }
            
            return location
        }
        
        return nil
    }
    
    func deleteLocation(location: Location?) {
        if let locationObject = location {
            contextObject!.deleteObject(locationObject)
            contextObject!.save(nil)
        }
    }
}