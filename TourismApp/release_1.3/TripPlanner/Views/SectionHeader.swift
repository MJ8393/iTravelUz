//
//  SectionHeader.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 16/01/24.
//

import UIKit

class SectionHeader: UIView {
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setData(title: String) {
        label.text = title
    }
}
