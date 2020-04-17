//
//  ViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 05/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomBar: UIView!
    var listViewController: UIViewController?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Usually we set data here, no final sizes are set here
        drawView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadUserCities()
    }
    
    @IBAction func unitTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

private extension ViewController {
    
    func drawView() {
        let gradientLayer = CAGradientLayer()
               gradientLayer.colors = [UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor, UIColor.white.cgColor]
               gradientLayer.startPoint = CGPoint(x: 0, y: 0)
               gradientLayer.endPoint = CGPoint(x: 0, y: 1)
               gradientLayer.frame = view.bounds
               view.layer.insertSublayer(gradientLayer, at: 0)
               
               let mask = CAShapeLayer()
               
               mask.frame = bottomBar.bounds
               
               let path = UIBezierPath(rect: bottomBar.bounds)
               
               let amplitude: CGFloat = 0.1
               
               let width = bottomBar.frame.width
               let height = bottomBar.frame.height
               let origin = CGPoint(x: 0, y: height / 2)
               path.move(to: origin)
               for angle in stride(from: 0, through: 360.0, by: 5.0) {
                   let x = origin.x + CGFloat(angle/360.0) * width
                   let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
                   path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: bottomBar.frame.width, y: 0))
        path.addLine(to: CGPoint.zero)
        
        path.close()
        
        mask.path = path.cgPath
        
        bottomBar.layer.mask = mask
    }
    
    func showCityList(_ weathers: [CityWeather]) {
        if let cityListVC = listViewController as? LocationListViewController {
            print(weathers)
            cityListVC.cityList = weathers
            
        }else {
            let cityListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LocationListViewController") as! LocationListViewController
            
            cityListVC.cityList = weathers
            self.listViewController = cityListVC
            view.insertSubview(cityListVC.view, belowSubview: bottomBar)
            
            cityListVC.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(cityListVC)
            
            cityListVC.view.snp.makeConstraints { maker in
                maker.top.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.leading.trailing.equalToSuperview()
            }
        }
    }
    
    func downloadUserCities() {
        if let cityListData = UserDefaults.standard.data(forKey: "CityList") {
            let decoder = JSONDecoder()
            do {
                let cityList = try decoder.decode(CityList.self, from: cityListData)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    var weatherList: [CityWeather] = []
                    let group = DispatchGroup()
                    
                    cityList.cities.forEach{ city in
                        group.enter()
                        WeatherRepository.get5DaysForecast(for: city.name) { (forecast, error) in
                            group.leave()
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
                            
                            let cityWeather = CityWeather(cityName: city.name, temperature: dailyForecast[0].main.temp, description: dailyForecast[0].weather[0].weatherDescription, icon: dailyForecast[0].weather[0].icon)
                            
                            weatherList.append(cityWeather)
                        }
                        group.wait()
                        if let lastWeather = weatherList.last {
                            group.enter()
                            ImageRepository.getImage(for: lastWeather.icon) { image in
                                group.leave()
                                if let responseImage = image {
                                    lastWeather.image = responseImage
                                }
                            }
                        }
                    }
                    group.wait()
                    DispatchQueue.main.async {
                        self.showCityList(weatherList)
                    }
                }
            } catch {
                
                print(error)
                
            }
        }
    }
}
