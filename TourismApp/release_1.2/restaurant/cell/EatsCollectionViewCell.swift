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
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1
        nameLabel.text = ""
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
            make.height.equalTo(160.0)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.right.equalTo(imageView)
        }
    }
    
    func setMeal(meal: MealModel) {
        imageView.loadImage(url: meal.photo)
        nameLabel.text = meal.name
    }
}
