//
//  NoInternetView.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/12/23.
//

import UIKit

protocol NoInternetViewDelegate: AnyObject {
    func reloadTapped()
}

class NoInternetView: UIView {
    
    weak var delegate: NoInternetViewDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Please check your internet connection and reload the page"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var reloadAccount: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.layer.cornerRadius = 16
        registerButton.backgroundColor = .label
        registerButton.setTitle("Reload", for: .normal)
        registerButton.tintColor = .systemBackground
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        registerButton.addTarget(self, action: #selector(reloadAccountTarget), for: .touchUpInside)
        return registerButton
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
        
        subView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
        }
        
        subView.addSubview(reloadAccount)
        reloadAccount.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc func reloadAccountTarget() {
        delegate?.reloadTapped()
    }
    
    
}
