//
//  ProductCollectionViewCell.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 22/07/24.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 0.06).cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.backgroundColor = UIColor(named: "tabbar")
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.image = UIImage(named: "korzinka")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.text = "Lagancha"
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ant-design_star-filled")!
        return imageView
    }()
    
    lazy var starLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "5.0"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "24$"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
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
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(180)
        }
        
        subView.addSubview(starLabel)
        starLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(mainImageView.snp.bottom).offset(8)
        }
        
        subView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.right.equalTo(starLabel.snp.left).offset(-8)
            make.centerY.equalTo(starLabel)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualTo(starImageView.snp.left).offset(-8)
            make.centerY.equalTo(starLabel)
        }
        
        subView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with product: ProductModel) {
        nameLabel.text = product.name
        starLabel.text = String(format: "%.1f", product.overallRanking ?? 0)
        
        let priceText = product.price != nil ? String(format: "%.2f", product.price!) : "N/A"
        priceLabel.text = "\(priceText) $"
        
        mainImageView.loadImageJava(url: product.imageUrl)
    }

    
    
    
    
    
}


