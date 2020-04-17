//
//  WeatherImage.swift
//  mvcSample
//
//  Created by Julia Debecka on 17/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AlamofireImage

enum WeatherImageAPI {
    case imageFor(String)

    private var basePath: String {
        return "https://openweathermap.org"
    }

    var path: String {
        return basePath + endpoint + imageCode + "@2x.png"
    }

    var imageCode: String {
        switch self {
        case .imageFor(let code):
            return code
        }
    }
    var url: URL? {
        return URL(string: path)
    }

    var endpoint: String {
        return "/img/wn/"
    }
}

struct ImageRepository {
    static func getImage(for code: String, completion: @escaping ((UIImage?) -> Void)) {
        execureRequest(.imageFor(code), completion: completion)
    }
    
    private static func execureRequest(_ request: WeatherImageAPI,
                                                   completion: @escaping ((UIImage?) -> Void)) {
        guard let requestUrl = request.url else { return }

        
        AF.request(requestUrl).responseImage(completionHandler: { (response) in
            
            if let data = response.data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                    }
            }else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "Cloud.sun"))
                }
            }
        })
    }
}
