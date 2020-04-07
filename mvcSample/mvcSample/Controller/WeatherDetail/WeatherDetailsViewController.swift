//
//  WeatherDetailsViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 02/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

final class WeatherDetailsViewController: UIViewController {
    @IBOutlet private weak var timeDateLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var recentTemperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionlabel: UILabel!
    @IBOutlet weak var weeklyWeatherCollectionView: UICollectionView!

    private let weeklyDataSource = WeeklyWeatherCollectionDataSource()

    var selectedCityName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchCurrentWeather()
        fetchForecast()
    }

    private func setupView() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMMM d"
        timeDateLabel.text = dateFormatter.string(from: date)

        weeklyWeatherCollectionView.dataSource = weeklyDataSource
    }

    private func fetchCurrentWeather() {
        guard let selectedCityName = selectedCityName else { return }
        WeatherRepository.getCurrentWeather(selectedCityName) { [weak self] (weather, error) in
            guard let weather = weather else { return }

            self?.cityLabel.text = weather.name
            self?.recentTemperatureLabel.text = String(format: "%.0f°", weather.main.temp)
            self?.weatherDescriptionlabel.text = weather.weather.first?.weatherDescription
        }
    }

    private func fetchForecast() {
        guard let selectedCityName = selectedCityName else {
            return
        }

        WeatherRepository.get5DaysForecast(for: selectedCityName) { [weak self] (forecast, error) in
            guard let forecast = forecast else { return }

            let dayInSeconds = 60 * 60 * 24
            var lastTimestamp = 0
            let dailyForecast = forecast.list.filter { (item) -> Bool in
                if item.dt - lastTimestamp > dayInSeconds {
                    lastTimestamp = item.dt
                    return true
                }
                return false
            }
            self?.weeklyDataSource.days = dailyForecast
            self?.weeklyWeatherCollectionView.reloadData()
        }
    }
}
