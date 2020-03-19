//
//  SearchViewController.swift
//  mvcSample
//
//  Created by Apple on 17/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//
import UIKit

final class SearchViewController: UIViewController {
    
    typealias SearchItem = (boldText: String, lightText: String)
    
    private let locationCellIdentifier = "locationIdentifier"
    private var items = [SearchItem(boldText: "Your currnenct location", lightText: ""),
                         SearchItem(boldText:"Warsaw", lightText: "Poland"),
                         SearchItem(boldText:"Gdynia", lightText: "Poland"),
                         SearchItem(boldText:"Milano", lightText: "Italy"),
                         SearchItem(boldText:"Viena", lightText: "Austria")]
    weak var tableView: UITableView!
    //jezeli widok zostanie odpiety od view kontrolera to stracimy do niego referencje, do table view bedzie podpiety nil
    
    override func loadView() {
        super.loadView() // pusty widok inicjalizacja, mamy podstawowa konfiguracje
        
        //to robi super view
        /*
        self.view = UIView()
        self.view.backgroundColor = .white
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         */
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        self.tableView = tableView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 62
        tableView.separatorStyle = .none
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false //nie beda uzywane maski, co sie kryja w loadview
        //jezeli nie zrobimy tego to system sprobuje sam utworzyc contrainty
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true//tak jak contraint do superview
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: locationCellIdentifier)
        
        tableView.dataSource = self
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor,
                                   UIColor(red: 55.0/255.0, green: 140.0/255.0, blue: 1.0, alpha: 1.0).cgColor]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 0, y: 1)
           gradientLayer.frame = view.bounds
           view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//kazda klase w naszym kodzie mozemy rozszerzyc
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()//content view jest charakterystyczny dla klas dziedzicqacy z klas cell
        if indexPath.row == 0 {
            LocationTableViewCell.hasBeenCreated = false
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
       
//        cell.textLabel?.text = items[indexPath.row]
        cell.model = items[indexPath.row]
        
        
        return cell
    }
}
