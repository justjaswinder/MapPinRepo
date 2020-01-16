//
//  Location+CoreDataProperties.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-15.
//  Copyright © 2020 MacStudent. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: Int32
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
