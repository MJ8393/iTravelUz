//
//  TableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 10/09/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    weak var delegate: ViewAllVCDelegate?
    static let identifier = "TableViewCell"
    
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
        headerLabel.textColor = .black
        headerLabel.font = .boldSystemFont(ofSize: 17)
        headerLabel.text = "City Label"
        return headerLabel
    }()
    
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = .black
        locationLabel.text = "Tashkent, Uzbekistan"
        return locationLabel
    }()
    
    
    private let locationButton: UIButton = {
        let locationButton = UIButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.tintColor = .black
        locationButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "mappin.and.ellipse")
        locationButton.setImage(image)
        locationButton.layer.cornerRadius = 12.5
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return locationButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let properties = [headerImageView, cityLabel, locationLabel, locationButton]
        for property in properties { contentView.addSubview(property) }
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(destination: MainDestination) {
        headerImageView.image = nil
        cityLabel.text = destination.name?.getName()
        locationLabel.text = "\(destination.city_name?.getCityName() ?? ""), Uzbekistan"
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
        locationLabel.text = "\(city.country?.getCountry())"
        if let gallery = city.gallery {
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
        
        let locationButtonConstraints = [
            locationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            locationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationButton.heightAnchor.constraint(equalToConstant: 25),
            locationButton.widthAnchor.constraint(equalToConstant: 25)
        ]
        
        let constraints = [headerImageViewConstraints, cityLabelConstraints, locationLabelConstraints, locationButtonConstraints]
        for constraint in constraints { NSLayoutConstraint.activate(constraint) }
    
    }
   
    
    @objc func locationButtonTapped() {
        delegate?.locationButtonTapped()
    }
}
