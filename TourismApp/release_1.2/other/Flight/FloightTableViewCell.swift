//
//  FloightTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 16/12/23.
//

import UIKit

class FloightTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "Tashkent - Bukhara"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "From 323 434 UZS"
        label.textColor = .label
        return label
    }()

    lazy var goImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.right")!
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        return imageView
    }()

    private func initView() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
        }
        
        subView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(fromLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(goImageView)
        goImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(flight: Flight) {
        fromLabel.text = "\(flight.fromCity) - \(flight.toCity)"
        priceLabel.text = "\(flight.price)"
    }
}
