
//
//  HeaderImagesCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 23/10/23.
//

import UIKit

class HeaderImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "HeaderImagesCollectionViewCell"
    
    private var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Registan")!
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = contentView.bounds
    }
    
    func setImage(with: String) {
        guard let url = URL(string: "") else { return }
        headerImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                print("Image loaded successfully")
            case .failure(let error):
                print("Error loading image: ", error.localizedDescription)
            }
        }
    }
}
