//
//  CommentsTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/10/23.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.text = "comments".translate() + "(0)"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setCommands(count: Int) {
        commentsLabel.text = "comments".translate() + "(\(count))"
    }
}

