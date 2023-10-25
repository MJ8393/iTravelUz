//
//  CustomNavButton.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 23/09/23.
//

import UIKit

class CustomBarButtonView: UIView {
    
    var buttonAction: (() -> Void)?
    
    lazy var customButton: BaseButton = {
        let button = BaseButton()
        return button
    }()
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        customButton.backgroundColor = UIColor.clear
        customButton.layer.cornerRadius = 40 / 2
        customButton.setImage(image, for: .normal)
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = .label
        customButton.imageView!.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        self.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.buttonAction?()
    }
}


class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}
