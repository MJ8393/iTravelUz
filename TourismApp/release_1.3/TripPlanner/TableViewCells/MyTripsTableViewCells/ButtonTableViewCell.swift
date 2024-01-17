//
//  ButtonTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    weak var delegate: NoTripsViewControllerDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func createButtonPressed() {
        delegate?.createButtonPressed()
    }

    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }
}
