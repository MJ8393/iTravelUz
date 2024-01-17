//
//  InterestsCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 13/01/24.
//

import UIKit

class InterestsCollectionViewCell: UICollectionViewCell {
    
    var isAlreadySelected: Bool = false
    
    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 0.06).cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.backgroundColor = UIColor(named: "tabbar")
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCheckStatus() {
        isAlreadySelected.toggle()
        titleLabel.textColor = isAlreadySelected ? .white : .label
        imageView.tintColor = isAlreadySelected ? .white : .label
        subView.backgroundColor = isAlreadySelected ? .mainColor : UIColor(named: "tabbar")
    }
    
    func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setData(title: String, imageName: String) {
        titleLabel.text = title
        imageView.image = UIImage(systemName: imageName)
    }
}
