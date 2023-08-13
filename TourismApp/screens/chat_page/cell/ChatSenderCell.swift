//
//  ChatSenderCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//


import UIKit

class ChatSenderCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(text: String) {
        mainLabel.text = text
    }
    
    private func initView() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(UIScreen.main.bounds.width * 3 / 4)
            make.right.equalToSuperview().offset(-16)
        }
        
        containerView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
}

