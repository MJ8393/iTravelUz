//
//  InfoWindowVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 18/09/23.
//

import UIKit

class InfoWindowVC: SearchVC {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Samarkand"
        label.textColor = .black
        return label
    }()
    
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = .zero
    }
}
