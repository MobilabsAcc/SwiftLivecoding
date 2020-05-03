//
//  LocationWeatherViewModel.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 30/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

class LocationWeatherViewModel {
    
    let temperature: String
    let cityName: String
    
    init(_ cityWeather: CityWeather) {
        temperature = "\(cityWeather.temperature)"
        cityName = cityWeather.cityName
    }
}
