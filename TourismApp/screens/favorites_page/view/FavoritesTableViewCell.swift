//
//  FavoritesTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/09/23.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.systemGray6
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Labihovuz"
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Bukhara, Uzbekistan"
        label.textColor = UIColor.label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(destionation: MainDestination) {
        if let gallery = destionation.gallery {
            if !gallery.isEmpty {
                iconImageView.loadImage(url: gallery[0].url)
            } else {
                iconImageView.stopLoading()
                iconImageView.image = nil
            }
        } else {
            iconImageView.stopLoading()
            iconImageView.image = nil
        }
        nameLabel.text = destionation.name?.getName()
        if let city_name = destionation.city_name?.getCityName() {
            cityLabel.text = "\(city_name)" + "country_name".translate()
        }
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(110)
            make.width.equalTo(130)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
        
        subView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
}
