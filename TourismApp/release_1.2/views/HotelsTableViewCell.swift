//
//  HotelsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 03/12/23.
//

import UIKit

class HotelsTableViewCell: UITableViewCell {
    
    static let identifier = "HotelsTableViewCell"
    
    lazy var mainImageView: UIImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: "Registan")
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.text = "Hilton"
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var ratingImageView: UIImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "star2")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        configureCell()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingImageView)
    }
    
    func applyConstraints() {
        mainImageView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(snp_leading).offset(10)
            make.trailing.equalTo(snp_leading).offset(110)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        nameLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(mainImageView.snp_trailing).offset(20)
            make.trailing.equalTo(mainImageView.snp_trailing).offset(150)
            make.height.equalTo(25)
        }
        
        ratingImageView.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(20)
            make.leading.equalTo(mainImageView.snp_trailing).offset(20)
            make.trailing.equalTo(mainImageView.snp_trailing).offset(100)
            make.height.equalTo(30)
        }
    }
}
