//
//  DayTripTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class DayTripTableViewCell: UITableViewCell {
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)
    var isShowingDescription: Bool = false
    var onArrowClick: ((UIView)->())!
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPlace))
        contentView.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.backgroundColor = .clear
        imageView.tintColor = .mainColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    lazy var mainImageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Registan")
        return imageView
    }()
    
    lazy var orderNumberView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Registan, Samarkand"
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.backgroundColor = .clear
        imageView.tintColor = .mainColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Located near the Spice Souk in Dubai, Al Bait Al Qadeem Restaurant and Cafe is a local gem that offers a delightful dining experience. This restaurant is perfect for history enthusiasts like you, as it is situated in the historic Al Fahidi Historical Neighbourhood. With its old-style Arabic ambiance, it provides a unique and authentic atmosphere for you to enjoy. The menu offers a variety of delicious local dishes, including traditional Emirati cuisine. Whether you choose to dine inside or in the charming garden area, you will be treated to great service and reasonably priced, well-cooked meals. Make sure to try the Lugaymat and Kunafa desserts for a truly indulgent experience. Al Bait Al Qadeem is a must-visit spot for anyone looking to explore the rich history and flavors of Dubai."
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(orderNumberView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        containerView.updateConstraints()
    }
    
    func removeDescriptionLabel() {
        descriptionLabel.removeFromSuperview()
        containerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func updateArrowImage(expandStatus: Bool){
        arrowImageView.image = expandStatus ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        expandStatus ? addDescriptionLabel() : removeDescriptionLabel()
    }
    
    @objc func didTapPlace() {
        onArrowClick(containerView)
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.height.width.equalTo(35)
        }
        
        subView.addSubview(verticalLineView)
        verticalLineView.snp.makeConstraints { make in
            make.top.equalTo(locationImageView.snp.bottom).offset(20)
            make.centerX.equalTo(locationImageView)
            make.width.equalTo(1)
            make.height.equalTo(150)
        }
        
        subView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(locationImageView)
            make.leading.equalTo(locationImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(verticalLineView.snp.bottom).offset(20)
        }
        
        subView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(verticalLineView.snp.bottom).offset(30)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(orderNumberView)
        orderNumberView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(verticalLineView)
            make.height.width.equalTo(30)
        }
        
        containerView.addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(orderNumberView)
        }
        
        containerView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(orderNumberView)
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(30)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(orderNumberView)
            make.leading.equalTo(orderNumberView.snp.trailing).offset(25)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    func setDestination(model: MainDestination, orderNumber: Int) {
        mainImageView.loadImage(url: model.gallery?[0].url)
        nameLabel.text = (model.name?.getName() ?? "")
        descriptionLabel.text = model.description?.getDescription()
        orderNumberLabel.text = String(orderNumber)
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
    }
    
    func setRestaurant(model: RestaurantModel, orderNumber: Int) {
        mainImageView.loadImage(url: model.photos?[0])
        nameLabel.text = (model.name)
//        descriptionLabel.text = model.
        orderNumberLabel.text = String(orderNumber)
        locationImageView.image = UIImage(systemName: "fork.knife")
    }
    
    func setHotel(model: HotelModel, orderNumber: Int) {
        mainImageView.loadImage(url: model.photos?[0])
        nameLabel.text = (model.name)
        descriptionLabel.text = model.description
        orderNumberLabel.text = String(orderNumber)
        locationImageView.image = UIImage(systemName: "bed.double")
    }
}
