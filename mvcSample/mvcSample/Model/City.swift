//
//  Country.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 24/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object, Codable {
    @objc dynamic var country: String
    @objc dynamic var name: String
}
