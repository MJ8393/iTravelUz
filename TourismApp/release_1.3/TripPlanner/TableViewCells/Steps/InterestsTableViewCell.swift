//
//  InterestsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class InterestsTableViewCell: UITableViewCell {
    
    var isInterest: Bool = false
    var isAlreadySelected: Bool = false
    
    lazy var subView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectCell))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shopping"
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "circle")
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelectCell() {
        if isInterest {
            isAlreadySelected.toggle()
            updateCheckStatus()
        } else {
            guard let tableView = self.superview as? UITableView,
                  let indexPath = tableView.indexPath(for: self) else {
                return
            }
            for i in 0..<tableView.numberOfRows(inSection: indexPath.section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? InterestsTableViewCell {
                    cell.isAlreadySelected = false
                    cell.updateCheckStatus()
                }
            }
            isAlreadySelected.toggle()
            updateCheckStatus()
        }
    }
    
    func updateCheckStatus() {
        checkImageView.image = isAlreadySelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkImageView.tintColor = isAlreadySelected ? .mainColor : .label
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(checkImageView)
        checkImageView.snp_makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-30)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}
