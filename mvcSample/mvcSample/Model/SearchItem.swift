//
//  SearchItem.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 24/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

struct SearchItem {
    enum ItemType {
        case plain
        case history
        case currentLocation
    }

    let city: String
    let country: String
    let alternativeText: String
    var type: ItemType
}
