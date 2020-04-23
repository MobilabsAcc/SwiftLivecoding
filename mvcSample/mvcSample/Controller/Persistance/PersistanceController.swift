//
//  PersistanceController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 23/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

final class PersistanceController {
    static let shared = PersistanceController()

    let persistentContainer = NSPersistentContainer(name: "WeatherDataModel")

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    private init() {
    }

    func initalizeStack() {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }

            print("store loaded")
        }
    }

    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]? {
        let fetchReq = type.fetchRequest()
        do {
            let data = try context.fetch(fetchReq)
            if data.isEmpty {
                return nil
            }
            print("Got \(data.count) objects")
            return data as? [T]
        } catch {
            assertionFailure("Fetch failed")
        }
        return nil
    }

    func save() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
