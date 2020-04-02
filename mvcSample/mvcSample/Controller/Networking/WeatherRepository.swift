//
//  WeatherRepository.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 26/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case weatherForCity(String)

    private var basePath: String {
        return "https://api.openweathermap.org/data/2.5"
    }

    var path: String {
        return basePath + endpoint
    }

    var url: URL? {
        return URL(string: path)
    }

    var endpoint: String {
        switch self {
        case .weatherForCity:
            return "/weather"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var queryParams: Parameters {
        var params = ["appid": "8ff1fb3e2647bfd32f6ac1aa277253f7",
                      "units": "metric"]
        switch self {
        case .weatherForCity(let city):
            params["q"] = city
        }

        return params
    }
}

struct WeatherRepository {
    static func get(_ cityName: String, completion: @escaping ((Weather?, Error?) -> Void)) {
        execureRequest(.weatherForCity(cityName), completion: completion)
    }

    private static func execureRequest<T: Codable>(_ request: WeatherAPI,
                                                   completion: @escaping ((T?, Error?) -> Void)) {
        guard let requestUrl = request.url else { return }

        AF
            .request(requestUrl,
                     method: request.method,
                     parameters: request.queryParams)
            .response { response in
                guard let data = response.data else { return }

                do {
                    let decoder = JSONDecoder()
                    let responseObject: T = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
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
