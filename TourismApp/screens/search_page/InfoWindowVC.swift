//
//  InfoWindowVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 18/09/23.
//

import UIKit

class InfoWindowVC: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Samarkand"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let goButton: UIButton = {
        let goButton = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = .systemBlue
        goButton.setTitle("Open Google Maps", for: .normal)
        goButton.layer.cornerRadius = 8
        return goButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(goButton)
        applyConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 15, y: 20, width: label.frame.size.width, height: label.frame.size.height)
    }
    
    func applyConstraints() {
        let goButtonConstrains = [
            goButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            goButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 115),
            goButton.heightAnchor.constraint(equalToConstant: 40),
            goButton.widthAnchor.constraint(equalToConstant: 160)
        ]
        
        NSLayoutConstraint.activate(goButtonConstrains)
    }
}
