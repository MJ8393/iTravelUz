//
//  RestaurantTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 04/12/23.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
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
        imageView.image = UIImage(named: "hyatt")!
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Best Restaurant Ever"
        label.textColor = .label
        return label
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 7")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Tashkent, Uzbekistan"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
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
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(120)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView).offset(10)
            make.left.equalTo(mainImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.height.width.equalTo(18)
            make.centerY.equalTo(mainImageView)
        }
        
        subView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(locationImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(locationImageView)
        }
        
        subView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.bottom).offset(-10)
            make.left.equalTo(locationImageView)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(starLabel)
        starLabel.snp.makeConstraints { make in
            make.left.equalTo(starImageView.snp.right).offset(8)
            make.bottom.equalTo(starImageView)
            make.right.equalToSuperview().offset(-20)
        }
    }

    func setData(model: RestaurantModel) {
        if let photos = model.photos, photos.count != 0 {
            mainImageView.loadImage(url: photos[0])
        }
        nameLabel.text = model.name ?? "No name"
        locationLabel.text = model.city ?? "No location"
        starLabel.text = "5.0"
    }
}
