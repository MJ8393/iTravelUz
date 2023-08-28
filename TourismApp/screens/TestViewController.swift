//
//  TestViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 28/08/23.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        let button = UIButton()
        button.setTitle("Chat")
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        let vc = ChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
