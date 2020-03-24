//
//  SearchViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 17/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit
import CoreLocation

final class SearchViewController: UIViewController {
    typealias SearchItem = (boldText: String, lightText: String)

    private let locationCellIdentifier = "locationCell"

    private var items = [SearchItem(boldText: "Warsaw", lightText: "Poland"),
                         SearchItem(boldText: "Gdynia", lightText: "Poland"),
                         SearchItem(boldText: "Milano", lightText: "Italy"),
                         SearchItem(boldText: "Viena", lightText: "Austia")]
    private var filteredItems = [SearchItem]()
    private var isFiltering = false
    private var tapGestureRecogniser: UITapGestureRecognizer!
    private lazy var locationManager: CLLocationManager = CLLocationManager()

    weak var tableView: UITableView!
    var searchBar: UISearchBar!

    override func loadView() {
        super.loadView()

        let tableView = UITableView()
        self.searchBar = UISearchBar()
        self.tapGestureRecogniser = UITapGestureRecognizer()
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.tableView = tableView
        self.tableView.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        tapGestureRecogniser.addTarget(self, action: #selector(hideKeyboard))
        searchBar.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 62
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: locationCellIdentifier)

        tableView.dataSource = self

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 55.0/255.0, green: 140.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredItems.count : items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }

        if isFiltering {
            cell.model = filteredItems[indexPath.row]
        } else {
            cell.model = items[indexPath.row]
        }

        cell.cellType = indexPath.row == 0 ? .location : .history

        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFiltering = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isFiltering = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            hideKeyboard()
        } else {
            filteredItems = items.filter({ $0.boldText.contains(searchText) })
        }
        tableView.reloadData()
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            items.insert(SearchItem(boldText: "Your current location", lightText: ""), at: 0)
            tableView.reloadData()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if items.count > 0,
            let location = locations.first {
            let newItem = SearchItem(boldText: "\(location.coordinate.latitude) \(location.coordinate.longitude)", lightText: "")
            
            items.remove(at: 0)
            items.insert(newItem, at: 0)
            tableView.reloadData()
        }
    }
}
