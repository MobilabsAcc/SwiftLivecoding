//
//  WeatherRepository.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 26/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

struct WeatherRepository {
    static let address = "https://api.openweathermap.org/data/2.5/weather?appid=8ff1fb3e2647bfd32f6ac1aa277253f7&units=metric"

    static func get(_ cityName: String, completion: @escaping ((Weather?) -> Void)) {
        
        let fullUrl = address + "&q=" + cityName
        if let citiesURL = URL(string: fullUrl) {
            let datatask = URLSession.shared.dataTask(with: citiesURL) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let weather: Weather = try decoder.decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        completion(weather)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            datatask.resume()
        }
    }
}

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let id: Int
    let name: String
    let cod: Int
}

 

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

 

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

 

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double

 

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}


// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

 

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

 

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
