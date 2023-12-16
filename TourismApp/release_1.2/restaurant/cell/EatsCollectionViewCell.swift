//
//  EatsCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 16/12/23.
//

import UIKit

class EatsCollectionViewCell: UICollectionViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 0.06).cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.backgroundColor = UIColor(named: "tabbar")
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        return view
    }()
    
    lazy var imageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(named: "eats")
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.text = "Palov"
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
        
        subView.addSubview(imageView)
        imageView.snp_makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.width.equalTo(160.0)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(imageView)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setData(_ url: String, _ mealName: String) {
        imageView.loadImage(url: url)
        nameLabel.text = mealName
    }
}
