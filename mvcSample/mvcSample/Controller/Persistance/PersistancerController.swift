//
//  PersistancerController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 23/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class PersistanceController {
    static let shared = PersistanceController()

    private init() {}

    func initialize() {
        let _ = try! Realm()
    }

    func append(_ objects: [Object]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects)
        }
    }

    func fetch<T: Object>(_ type: T.Type) -> [T]? {
        let realm = try! Realm()
        let objects = realm.objects(type)
        if objects.isEmpty {
            return nil
        }
        return objects.map { $0 }
    }
}
