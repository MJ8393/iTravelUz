//
//  NoInternetViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/12/23.
//

import UIKit

class NoInternetViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var noInternetView: NoInternetView = {
        let view = NoInternetView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initViews()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(noInternetView)
        noInternetView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }

}
