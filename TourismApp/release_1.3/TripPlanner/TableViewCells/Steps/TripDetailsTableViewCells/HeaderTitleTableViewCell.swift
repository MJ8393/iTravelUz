//
//  HeaderTitleTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 07/01/24.
//

import UIKit

class HeaderTitleTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Your trip to Samarkand for 3 days"
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
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
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
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
        
        subView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.leading.equalTo(headerLabel)
            make.trailing.equalTo(headerLabel)
        }
        
        subView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func setData(title: String, description: String) {
        headerLabel.text = title
        descriptionLabel.text = description
    }
}
