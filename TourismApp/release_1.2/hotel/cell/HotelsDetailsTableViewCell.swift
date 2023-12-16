//
//  HotelsDetailsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 04/12/23.
//

import UIKit

class HotelsDetailsTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 7")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ant-design_star-filled")!
        return imageView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "5.0"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
//
//    lazy var playButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.backgroundColor = UIColor.mainColor
//        button.layer.cornerRadius = 20
//        button.clipsToBounds = true
//        let playIconImage = UIImage(systemName: "play.fill")
//        button.setImage(playIconImage, for: .normal)
//        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
//        button.tintColor = .white
//        return button
//    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20 - 40 - 10)
        }
        
//        subView.addSubview(playButton)
//        playButton.snp.makeConstraints { make in
//            make.centerY.equalTo(titleLabel)
//            make.right.equalToSuperview().offset(-20)
//            make.width.height.equalTo(40)
//        }
        
        subView.addSubview(locationImageView)
        locationImageView.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(37)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(ratingLabel)
        ratingLabel.snp_makeConstraints { make in
            make.centerY.equalTo(cityLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.right.equalTo(ratingLabel.snp.left).offset(-4)
            make.centerY.equalTo(ratingLabel)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

    func setData(_ id: String, _ name: String, _ city: String, _ description: String) {
        nameLabel.text = name
        cityLabel.text = city
        descriptionLabel.text = description
    }
}
