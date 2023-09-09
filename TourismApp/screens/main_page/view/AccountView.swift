//
//  AccountView.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 29/08/23.
//

import UIKit

class AccountView: UIView {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        img.image = UIImage(systemName: "person.crop.circle.fill")
        return img
    }()
    
    lazy var nameLabel = {
        let label = UILabel()
        label.text = "Mekhriddin"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
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
        
        subView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.width.equalTo(33)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.right.top.bottom.equalToSuperview()
        }
    }
}
