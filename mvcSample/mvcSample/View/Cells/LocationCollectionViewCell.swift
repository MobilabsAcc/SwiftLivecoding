//
//  LocationCollectionViewCell.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 19/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit
import SnapKit

class LocationCollectionViewCell: UICollectionViewCell {
   
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    lazy var cityName: UILabel  = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 15)
           return label
    }()
    
    var viewModel: LocationWeatherViewModel? {
        didSet{
            temperature.text = viewModel?.temperature
            cityName.text = viewModel?.cityName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        addSubview(temperature)
        addSubview(cityName)
        
        cityName.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
