//
//  SuggestedTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 30/12/23.
//

import UIKit

class SuggestedTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.image = UIImage(named: "Registan")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Registan"
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    lazy var cityNameLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .secondaryLabel
        authorLabel.textAlignment = .left
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.text = "Samarkand"
        return authorLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.height.width.equalTo(100)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.leading.equalTo(mainImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(cityNameLabel)
        cityNameLabel.snp_makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.centerY.equalToSuperview().offset(10)
            make.trailing.equalTo(nameLabel)
        }
    }
    
    func setData(with model: SearchDestinationModel) {
        mainImageView.loadImage(url: model.gallery?[0].url)
        nameLabel.text = model.name?.getName()
        cityNameLabel.text = model.city_name?.getCityName()
    }
}
