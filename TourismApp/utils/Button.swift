//
//  Button.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 13/01/24.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private func configure() {
        backgroundColor = .mainColor
        setTitleColor(.white, for: .normal)
    }
}
