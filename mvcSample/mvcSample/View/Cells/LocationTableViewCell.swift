//
//  LocationTableViewCell.swift
//  mvcSample
//
//  Created by Apple on 17/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//
import UIKit

class LocationTableViewCell: UITableViewCell {
    static var hasBeenCreated = false
    private let separatorView = UIView()
    //xib to uproszczony storyboard
    var model: SearchViewController.SearchItem! {
        didSet {
            let attributedString = NSMutableAttributedString()
            let lightAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light),
                                   NSAttributedString.Key.foregroundColor: UIColor.white]
            let mediumAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.medium),
                                    NSAttributedString.Key.foregroundColor: UIColor.white]

            attributedString.append(NSAttributedString(string: model.0,
                                                       attributes: mediumAttributes))
            if !model.1.isEmpty {
            attributedString.append(NSAttributedString(string: " / ",
                                                       attributes: mediumAttributes))
            attributedString.append(NSAttributedString(string: model.1,
                                                       attributes: lightAttributes))
            }
            textLabel?.attributedText = attributedString
        }
    }//korzystajac z tupli potem te nazwy zamieniaja sie na 0, 1, 2..
    
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
        //jezeli ustawilbym 10 to bysmy wyjechali za ekran
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //new code
       
        var accessoryImageType = Icons.paperplane.image
        if LocationTableViewCell.hasBeenCreated {
            accessoryImageType = Icons.clock.image
        }
        //za pomoca enuma z var image zdefiniowac clock i paperplane i cell ma przyjmowac enuma
        LocationTableViewCell.hasBeenCreated = true
        let imageView = UIImageView(image: accessoryImageType)
        imageView.tintColor = .white
        accessoryView = imageView
    }

}

enum Icons{
    case paperplane, clock
    var image: UIImage {
        switch self {
        case .paperplane:
            return UIImage(systemName: "paperplane.fill") ?? UIImage(systemName: "multiply.circle")!
        case .clock:
            return UIImage(named: "clock") ?? UIImage(systemName: "multiply.circle")!
        }
    }
}
