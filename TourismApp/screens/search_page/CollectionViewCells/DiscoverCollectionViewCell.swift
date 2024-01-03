//
//  DiscoverCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 30/12/23.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass")
        return imageView
    }()
    
    lazy var searchSampleLabel: UILabel = {
        let label = UILabel()
        label.text = "samarkand"
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(containerView)
        containerView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(searchIconImageView)
        searchIconImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(16)
        }
        
        containerView.addSubview(searchSampleLabel)
        searchSampleLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(7)
        }
    }
    
    func setData(with title: String) {
        searchSampleLabel.text = title
    }
}
