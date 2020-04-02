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
    var selectedCityName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMMM d"
        timeDateLabel.text = dateFormatter.string(from: date)

        guard let selectedCityName = selectedCityName else { return }
        WeatherRepository.get(selectedCityName) { [weak self] (weather, error) in
            guard let weather = weather else { return }

            self?.cityLabel.text = weather.name
            self?.recentTemperatureLabel.text = "\(weather.main.temp)°"
            self?.weatherDescriptionlabel.text = weather.weather.first?.weatherDescription
        }
    }
}
