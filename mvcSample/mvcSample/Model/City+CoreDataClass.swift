//
//  Country.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 24/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(name ?? "blank", forKey: .name)
        } catch {
            print("error")
        }
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext) else {
                fatalError("Failed to decode City")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            country = try values.decode(String.self, forKey: .country)
            name = try values.decode(String.self, forKey: .name)
        } catch {
            print ("error")
        }
    }

    enum CodingKeys: String, CodingKey {
        case country
        case name
    }
}
