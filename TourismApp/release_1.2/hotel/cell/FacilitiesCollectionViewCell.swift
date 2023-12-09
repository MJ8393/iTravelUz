//
//  ServicesCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/12/23.
//

import UIKit

class FacilitiesCollectionViewCell: UICollectionViewCell {
    
    lazy var subView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var iconBackView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40.0 / 2
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(iconBackView)
        iconBackView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40.0)
        }
        
        subView.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { make in
            make.centerX.centerY.equalTo(iconBackView)
            make.height.width.equalTo(25.0)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalTo(iconImageView)
            make.bottom.equalToSuperview().offset(5)
        }
    }
    
    func setData(_ iconTitle: String, _ name: String) {
        iconImageView.image = UIImage(systemName: iconTitle)
        nameLabel.text = name
    }
}
