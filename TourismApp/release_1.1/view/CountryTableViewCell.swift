//
//  CountryTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/11/23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var chooseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "choose")!
        imageView.isHidden = true
        return imageView
    }()

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
        
        subView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
        }
        
        subView.addSubview(chooseImageView)
        chooseImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(22)
        }
    }
}
