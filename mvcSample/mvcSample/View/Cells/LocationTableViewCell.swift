//
//  LocationTableViewCell.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 17/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

final class LocationTableViewCell: UITableViewCell {
    
    var cityName: String = " "
    var countryName: String = " "
    
    enum CellType {
        case empty
        case location
        case history
        
        var accessoryImage: UIImage? {
            switch self {
            case .location:
                return UIImage(systemName: "paperplane.fill")
            case .history:
                return UIImage(named: "clock")
            default:
                return nil
            }
        }
    }
    
    private var cellType: CellType = .empty {
        didSet {
            let imageView = UIImageView(image: cellType.accessoryImage)
            imageView.tintColor = .white
            accessoryView = imageView
        }
    }
    
    private let separatorView = UIView()
    
    var type: ItemType = .plain {
        didSet{
            switch self.type {
            case .currentLocation:
                textLabel?.text = "Current Location"
                cellType = .location
            case .history:
                setupDataForCity()
                cellType = .history
            case .plain:
                setupDataForCity()
                cellType = .empty
            }
        }
    }
    
    var model: City! {
        didSet {
            cityName = model.name
            countryName = model.country
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupDataForCity() {
        let attributedString = NSMutableAttributedString()
        let lightAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light),
                               NSAttributedString.Key.foregroundColor: UIColor.white]
        let mediumAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.medium),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        
        attributedString.append(NSAttributedString(string: cityName,
                                                   attributes: mediumAttributes))
        if !model.country.isEmpty {
            attributedString.append(NSAttributedString(string: ", ",
                                                       attributes: mediumAttributes))
            attributedString.append(NSAttributedString(string: countryName,
                                                       attributes: lightAttributes))
        }
        textLabel?.attributedText = attributedString
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 24.0, weight: .medium)
        
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23.0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 28.0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
