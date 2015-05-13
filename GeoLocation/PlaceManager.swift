//
//  PlaceManager.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import Alamofire

class PlaceManager {
    lazy var coreData:CoreDataManager? = CoreDataManager.SharedManager
    
    var contextObject:NSManagedObjectContext? {
        get {
            if let context = coreData?.managedObjectContext {
                return context
            }
            return nil
        }
    }
    
    class var SharedManager: PlaceManager {
        struct Singleton {
            static let instance = PlaceManager()
        }
        
        Singleton.instance.coreData = CoreDataManager.SharedManager
        return Singleton.instance
    }
    
    func fetchPlace(predicate : NSPredicate) -> Place? {
        
        if let places = fetchPlaces(predicate, sortDescriptors: nil) {
            return places[0]
        }
        
        return nil
    }
    
    func fetchPlaces(predicate : NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [Place]? {
        let fetchRequest = NSFetchRequest(entityName: "Place")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        var error: NSError? = nil
        
        let results = contextObject!.executeFetchRequest(fetchRequest, error: &error) as [Place]
        
        if results.count > 0 {
            return results
        }
        
        if error != nil {
            println(" Could not fetch data : \(error), \(error?.description) ")
        }
        
        return nil
    }
    
    func createPlaceWithName(name: String?) -> Place? {
        if let nameValue = name {
            let entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: contextObject!)
            
            let place = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: contextObject) as Place
            
            place.name = nameValue
            
            var error: NSError? = nil
            contextObject!.save(&error)
            
            if error != nil {
                println(" Could not save context : \(error), \(error?.description) ")
            }
            
            return place
        }
        
        return nil
    }
    
    func addNoteForPlace(place:Place, note:Float) -> Place {
        place.note = note
        place.managedObjectContext?.save(nil)
        
        return place
    }
}