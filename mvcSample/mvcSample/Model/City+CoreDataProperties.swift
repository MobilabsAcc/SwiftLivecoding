//
//  City+CoreDataProperties.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 23/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import CoreData

extension City {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var country: String
    @NSManaged public var name: String
}
