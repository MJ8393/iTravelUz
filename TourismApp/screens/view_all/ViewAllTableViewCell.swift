//
//  ViewAllTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 10/09/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    var coordinate: MainLocation?
    
    private let headerImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .systemGray6
        imageView.image = UIImage(named: "Registan")
        return imageView
    }()
    
    private let cityLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .label
        headerLabel.font = .systemFont(ofSize: 17, weight: .bold)
        headerLabel.text = "City Label"
        return headerLabel
    }()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = .label
        locationLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        locationLabel.text = "Tashkent, Uzbekistan"
        return locationLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let properties = [headerImageView, cityLabel, locationLabel]
        for property in properties { contentView.addSubview(property) }
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(destination: MainDestination) {
        headerImageView.image = nil
        self.coordinate = destination.location
        cityLabel.text = destination.name?.getName()
        locationLabel.text = "\(destination.city_name?.getCityName() ?? "")" + "country_name".translate()
        if let gallery = destination.gallery {
            if gallery.count != 0 {
                headerImageView.loadImage(url: gallery[0].url)
            } else {
                headerImageView.image = nil
                headerImageView.stopLoading()
            }
        } else {
            headerImageView.image = nil
            headerImageView.stopLoading()
        }
    }
    
    func setCity(city: City) {
        headerImageView.image = nil
        cityLabel.text = city.name?.getName()
        locationLabel.text = city.country?.getCountry()
        if let gallery = city.gallery {
            if gallery.count != 0 {
                headerImageView.loadImage(url: gallery[0])
            } else {
                headerImageView.image = nil
                headerImageView.stopLoading()
            }
        } else {
            headerImageView.image = nil
            headerImageView.stopLoading()
        }
    }
    
    func applyConstraints() {
        let headerImageViewConstraints = [
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            headerImageView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let cityLabelConstraints = [
            cityLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let locationLabelConstraints = [
            locationLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let constraints = [headerImageViewConstraints, cityLabelConstraints, locationLabelConstraints]
        for constraint in constraints { NSLayoutConstraint.activate(constraint) }
    }
}
