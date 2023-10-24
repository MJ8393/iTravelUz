//
//  ImageTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 21/09/23.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func setImage(url: String) {
        if let url = URL(string: "https://storage.googleapis.com/saam/\(url)") {
            iconImage.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    print("Image loaded successfully")
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}
