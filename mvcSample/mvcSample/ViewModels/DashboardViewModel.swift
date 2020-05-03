//
//  DashboardViewModel.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 30/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import Combine

protocol DashboardViewModelDelegate: AnyObject {
    func reloadData(_ data: [LocationWeatherViewModel])
}

class DashboardViewModel {
    
    weak var delegate: DashboardViewModelDelegate?
    
    var cityListViewModels: Box<[LocationWeatherViewModel]> = Box<[LocationWeatherViewModel]>([])
    
    private var cityList: [CityWeather] = []
    private var subscriptions = Set<AnyCancellable>()
    
    func loadData1(){
        
        guard let cityListData = UserDefaults.standard.data(forKey: "CityList") else {
            cityList = []
            return
        }
        let decoder = JSONDecoder()
        
        guard let storedCityList = try? decoder.decode(CityList.self, from: cityListData) else {
            cityList = []
            return
        }
            
        DispatchQueue.global().async {
            var weatherList = [CityWeather]()
            let group = DispatchGroup()
            
            storedCityList.cities.forEach{ city in
                group.enter()
                WeatherRepository.getCurrentWeather(city.title) { weather, error in
                    group.leave()
                    if let weather = weather {
                        let cityWeather = CityWeather(cityName: city.title, temperature: weather.main.temp)
                        weatherList.append(cityWeather)
                    }
                }
            }
            
            group.wait()
            DispatchQueue.main.async {
                self.cityList = weatherList
                self.cityListViewModels.value = weatherList.map{ LocationWeatherViewModel($0)}
                self.delegate?.reloadData(weatherList.map{ LocationWeatherViewModel($0)})
            }
        }
    }
    
    func loadDataWithComobine(){
        
        guard let cityListData = UserDefaults.standard.data(forKey: "CityList") else {
            cityList = []
            return
        }
        let decoder = JSONDecoder()
        
        guard let storedCityList = try? decoder.decode(CityList.self, from: cityListData) else {
            cityList = []
            return
        }
        // creating publisher that will emit only provided data and finish
        Just(storedCityList.cities)
            // changing the possible error type from default for Just 'Never' to 'ServiceError'
            .setFailureType(to: ServiceError.self)
            // the most interesting part🔥.
            .flatMap { cities -> AnyPublisher<[Weather?], ServiceError> in
                // Here we create publishers for fetching the weather for all the cities we got
                let weatherPublisher = cities.map { WeatherRepository.getCurrentWeather($0.title) }
                // Here we merge all our download streams into one. Thus any time a request will finish with data - a new event will be emitted.
                return Publishers.MergeMany(weatherPublisher)
                    // Wait until our new master stream finishes (when we receive response for all requests) and emit an array of all results
                    .collect()
                    // Combine magic -
                    .eraseToAnyPublisher()
            }
        // Data manipulation on Weather array
        .map{ weatherList in
            weatherList
                // filtering nils
                .compactMap{ $0 }
                // mapping each Weather object to CityWeather
                .map{ CityWeather(cityName: $0.name, temperature: $0.main.temp) }
                // mapping each CityWeather object to LocationWeatherViewModel
                .map{ LocationWeatherViewModel($0) }
        }
        // telling Combine to provide the result on the main queue
        .receive(on:  RunLoop.main)
        // here we subscribe for getting updates/results from our newly created stream
        .sink(
            // completion will inform us if the stream successfully or with failure
            receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("weather list was fetched successfuly")
            case .failure(let error):
                print("failed to fetch weather list due to: \(error)")
            }
        },
        // here we actually get the values from the stream :)
        receiveValue: { [weak self] weatherList in
            self?.cityListViewModels.value = weatherList
        }).store(in: &subscriptions)
    }
}
