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
        let attributedString = NSAttributedString(string: "hotels".translate(), attributes: attributes)
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
        let attributedString = NSAttributedString(string: "restaurants".translate(), attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: "flights".translate(), attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(thidButtonTapped), for: .touchUpInside)
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
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }
        
        subView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftButton.snp.right)
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }
        
        subView.addSubview(thirdButton)
        thirdButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(rightButton.snp.right)
            make.right.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }
    }
    
    @objc func leftButtonTapped() {
        callback?(0, currentIndeX)
        currentIndeX = 0
    }
    
    @objc func rightButtonTapped() {
        callback?(1, currentIndeX)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: "Restaurants", attributes: attributes)
        rightButton.setAttributedTitle(attributedString, for: .normal)
        currentIndeX = 1
    }
    
    @objc func thidButtonTapped() {
        callback?(2, currentIndeX)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mainColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: "Flights", attributes: attributes)
        thirdButton.setAttributedTitle(attributedString, for: .normal)
        currentIndeX = 2
    }
    
    func changeAttributes(c1: UIColor, c2: UIColor, c3: UIColor) {
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: c1,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString1 = NSAttributedString(string: "Hotels", attributes: attributes1)
        leftButton.setAttributedTitle(attributedString1, for: .normal)
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: c2,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString2 = NSAttributedString(string: "Restaurants", attributes: attributes2)
        rightButton.setAttributedTitle(attributedString2, for: .normal)
        
        let attributes3: [NSAttributedString.Key: Any] = [
            .foregroundColor: c3,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString3 = NSAttributedString(string: "Flights", attributes: attributes3)
        thirdButton.setAttributedTitle(attributedString3, for: .normal)
    }
}
