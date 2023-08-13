//
//  MainViewControllet.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Main"
        label.textColor = UIColor.black
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initViews()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    

}
