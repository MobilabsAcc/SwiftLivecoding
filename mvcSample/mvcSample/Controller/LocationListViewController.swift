//
//  LocationListViewController.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 19/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cityList: [CityWeather] = [CityWeather]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let rect = CGRect(x: 0, y: collectionView.contentSize.height, width: 30, height: 1)
//        collectionView.scrollRectToVisible(rect, animated: true)
//    }
}

extension LocationListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let city = cityList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocationCollectionViewCell
        cell.data = city
        return cell
    }
}

extension LocationListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard(name: "Main",
                                     bundle: nil)
            .instantiateViewController(identifier: "WeatherDetailsViewController") as! WeatherDetailsViewController

        detailsVC.selectedCityName = cityList[indexPath.row].cityName
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}


extension LocationListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width/2) - 30
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
}
