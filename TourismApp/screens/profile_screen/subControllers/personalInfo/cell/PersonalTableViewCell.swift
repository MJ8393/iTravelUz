//
//  PersonalTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 21/10/23.
//

import UIKit
import SwiftyStarRatingView

class PersonalTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Registan")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Registan Square"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Samarqand, Uzbekistan"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Such a great place to visit in Uzbekistan. Such a great place to visit in Uzbekistan.  Such a great place to visit in Uzbekistan.  Such a great place to visit in Uzbekistan. "
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()
    
    let starRatingView = SwiftyStarRatingView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        configureStarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(0)
            make.left.right.equalToSuperview()
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(0)
            make.height.width.equalTo(90)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView).offset(5)
            make.left.equalTo(mainImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(mainImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    

    func configureStarView() {
        starRatingView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.backgroundColor = .clear
        starRatingView.value = 3
        starRatingView.tintColor = UIColor.mainColor
        starRatingView.allowsHalfStars = false
        starRatingView.isUserInteractionEnabled = false
//        starRatingView.addTarget(self, action: #selector(starValueChanged), for: .valueChanged)
        contentView.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { make in
            make.left.equalTo(placeLabel)
            make.top.equalTo(placeLabel.snp.bottom).offset(5)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
    }
    
    func setStar(value: Int) {
        starRatingView.value = CGFloat(value)
    }
    
}
