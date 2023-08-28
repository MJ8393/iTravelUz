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
        imageView.image = UIImage(named: "test_icon")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
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
            make.top.left.right.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
    }
}
