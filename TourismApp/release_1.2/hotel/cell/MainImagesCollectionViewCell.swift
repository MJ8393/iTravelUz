//
//  MainImagesCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 04/12/23.
//

import UIKit

class MainImagesCollectionViewCell: UICollectionViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Registan")
        imageView.backgroundColor = .secondaryLabel
        return imageView
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
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(with url: String) {
        imageView.loadImage(url: url)
    }
}
