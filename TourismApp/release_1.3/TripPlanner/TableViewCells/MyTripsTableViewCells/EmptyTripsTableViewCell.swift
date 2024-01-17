//
//  EmptyTripsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/01/24.
//

import UIKit

class EmptyTripsTableViewCell: UITableViewCell {
    
    weak var delegate: EmptyTripsViewControllerDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView1: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.slash"))
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "No trips planned yet"
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "Looks like it's time to plan a new trip. There are two ways - use AI or search on your own"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    lazy var createBtn: Button = {
        let button = Button(title: "Create on your own")
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var createWithAIBtn: Button = {
        let button = Button(title: "Start a new trip with AI")
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(createWithAIButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func createButtonPressed() {
        
    }
    
    @objc func createWithAIButtonPressed() {
        delegate?.createWithAIButtonPressed()
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(imageView1)
        imageView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.width.height.equalTo(40)
        }
        
        subView.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(imageView1.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        subView.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        subView.addSubview(createBtn)
        createBtn.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(100)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(50)
        }
        
        subView.addSubview(createWithAIBtn)
        createWithAIBtn.snp.makeConstraints { make in
            make.top.equalTo(createBtn.snp.bottom).offset(15)
            make.leading.equalTo(createBtn)
            make.trailing.equalTo(createBtn)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
}
