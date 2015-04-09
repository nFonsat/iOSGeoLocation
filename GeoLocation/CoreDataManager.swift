//
//  CoreDataManager.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let managedObjectContext: NSManagedObjectContext
    let persistentStore: NSPersistentStore?
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let managedObjectModel: NSManagedObjectModel
    
    class var SharedManager: CoreDataManager {
        struct Singleton {
            static var instance: CoreDataManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Singleton.token) {
            Singleton.instance = CoreDataManager()
        }
        
        return Singleton.instance!
    }
    
    func applicationDocumentDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls[0] as NSURL
    }
    
    init() {
        let modelURL = NSBundle.mainBundle().URLForResource("GeoLocation", withExtension: "momd")!
        
        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let documentURL = applicationDocumentDirectory()
        
        let storeURL = documentURL.URLByAppendingPathComponent("GeoLocation.Sqlite")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption : true]
        
        var error:NSError? = nil
        
        persistentStore = persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: options,
            error: &error)
        
        if persistentStore == nil {
            println("Error adding persistence store: \(error)")
            abort()
        }
    }
    
    func saveContext() {
        var error: NSError? = nil
        
        if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
            println("Failed to save context \(error), \(error?.userInfo)")
        }
    }
}