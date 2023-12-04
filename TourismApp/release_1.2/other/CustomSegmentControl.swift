//
//  CustomSegmentControl.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 04/12/23.
//

import UIKit

typealias IndexCallback = (Int, Int) -> Void

class CustomSegmentControl: UIView {
    
    var callback: IndexCallback?
    
    var currentIndeX: Int = 0
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: "Hotels", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: "Restaurants", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
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
        
        subView.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        subView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
    }
    
    @objc func leftButtonTapped() {
        currentIndeX = 0
        self.leftButton.titleLabel?.textColor = .mainColor
        self.rightButton.titleLabel?.textColor = .gray
        callback?(0, 1)
    }
    
    @objc func rightButtonTapped() {
        currentIndeX = 1
        self.leftButton.titleLabel?.textColor = .gray
        self.rightButton.titleLabel?.textColor = .mainColor
        callback?(1, 0)
    }
}
