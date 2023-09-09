//
//  MainCollectionView.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 29/08/23.
//

import UIKit

class MainCollectionView: UICollectionViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Registan")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registon Square"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    lazy var starView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var addressLabel = {
        let label = UILabel()
        label.text = "Samarkhand, Uzbekistan"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
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
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mainIcon)
        mainIcon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mainIcon.snp.bottom).offset(10)
        }
        
        subView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
