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
    
    let time: () -> Int = {
        let date = Date()
         let calendar = Calendar.current
         return calendar.component(.hour, from: date)
    }
    
    lazy var temperarture: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    fileprivate lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var image: UIImage = {
        let image = UIImage()
        return image
    }()
    
    lazy var cityName: UILabel  = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let descriptionLbl: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12.0, weight: .thin)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
        
    }()
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.startPoint = CGPoint(x: 0.0, y: 0.0)
        gl.endPoint = CGPoint(x: 0.0, y: 1.0)
        gl.frame = self.bounds
        return gl
    }()
    
    var data: CityWeather! {
        didSet{
            guard let data = data else { return }
            idWeather = data.icon
            cityName.text = data.cityName
            descriptionLbl.text = data.description
            temperarture.text = String(format: "%.0f°", data.temperature)
            let color = self.color
            gradientLayer.colors = [color[0].cgColor, color[1].cgColor]
            image = data.image
            weatherImage.image = image
        }
    }
    
    fileprivate var idWeather: String = {
        let idCode: String = ""
        return idCode
    }()
    
    fileprivate let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpSnapKit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
        setUpSnapKit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder")
        setUpViews()
        setUpSnapKit()
    }
    
    func setCellShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3
        self.clipsToBounds = false
    }
    
    func roundCorner() {
        self.contentView.layer.cornerRadius = 12.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    enum ColorKind{
        case blue, grey, yellow, night
        
        var color: [UIColor] {
            switch self{
            case .blue:
                return [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.1803921569, green: 0.4588235294, blue: 1, alpha: 1)]
            case .grey:
                return [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
            case .yellow:
                return [#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1),#colorLiteral(red: 0.8931249976, green: 0.5340107679, blue: 0.08877573162, alpha: 1)]
            case .night:
                return [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.003921568627, green: 0.1921568627, blue: 0.3333333333, alpha: 1)]
            }
        }
    }
    
    lazy var color: [UIColor] = {
        let colorTable: [UIColor]

        if self.idWeather.contains("n"){
            return ColorKind.night.color
        }
        switch self.idWeather {
        case "13d", "09d", "10d", "11d", "50d":
            return ColorKind.grey.color
        case "01d", "02d":
            return ColorKind.yellow.color
        case "04d", "03d":
            return ColorKind.blue.color
        default:
            return ColorKind.blue.color
        }
    }()
    
    private func setUpViews(){
        setCellShadow()
        roundCorner()
        //stackView
        contentView.addSubview(cityName)
        contentView.addSubview(descriptionLbl)
        contentView.addSubview(stackView)
        
        contentView.addSubview(temperarture)
        contentView.addSubview(weatherImage)
        
        contentView.layer.insertSublayer(self.gradientLayer, at: 0)
        
        stackView.addArrangedSubview(cityName)
        stackView.addArrangedSubview(descriptionLbl)
        
    }
    
    fileprivate func setUpSnapKit(){
        
        stackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            
        }
        temperarture.snp.makeConstraints{ make in
            make.bottom.equalTo(snp.bottom).offset(-20)
            make.centerX.equalTo(snp.centerX)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.width.equalTo(snp.width).multipliedBy(0.3)
            make.height.equalTo(snp.height).multipliedBy(0.3)
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.top.equalTo(snp.top).offset(10)
        }
    }
}
