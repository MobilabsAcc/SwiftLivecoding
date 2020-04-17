//
//  CityWeather.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 26/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import UIKit

class CityWeather {
    let cityName: String
    var image: UIImage
    let temperature: Double
    let description: String
    let icon: String
    
    init(cityName: String, temperature: Double, description: String, icon: String) {
        self.cityName = cityName
        self.temperature = temperature
        self.description = description
        self.icon = icon
        image = UIImage()
    }
}
