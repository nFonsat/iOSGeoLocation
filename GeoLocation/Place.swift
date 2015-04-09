//
//  Place.swift
//  GeoLocation
//
//  Created by iem on 09/04/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import Foundation
import CoreData

class Place: NSManagedObject {

    @NSManaged var cat: String
    @NSManaged var name: String
    @NSManaged var detail: String
    @NSManaged var placeId: String
    @NSManaged var locations: NSSet

}
