//
//  Location.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var radius: NSNumber
    @NSManaged var places: NSSet

}
