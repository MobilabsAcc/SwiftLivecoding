//
//  CityRepository.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 24/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation

struct CityRepository {
    
    static func getAllCities(_ completion: @escaping (([City]) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
                do {
                    
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let cities: [City] = try decoder.decode([City].self, from: data)
                    DispatchQueue.main.async {
                        completion(cities)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }        
    }
}
