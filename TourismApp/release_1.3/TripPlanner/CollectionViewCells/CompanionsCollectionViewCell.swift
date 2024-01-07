//
//  CompanionsCollectionViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class CompanionsCollectionViewCell: UICollectionViewCell {
    
    var isAlreadySelected: Bool = false
    
    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 0.06).cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 1
        view.backgroundColor = UIColor(named: "tabbar")
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.borderWidth = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectCell))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didSelectCell() {
        guard let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else {
            return
        }
        for i in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: indexPath.section)) as? CompanionsCollectionViewCell {
                cell.isAlreadySelected = false
                cell.updateCheckStatus()
            }
        }
        isAlreadySelected.toggle()
        updateCheckStatus()
    }
    
    func updateCheckStatus() {
        titleLabel.textColor = isAlreadySelected ? .white : .label
        imageView.tintColor = isAlreadySelected ? .white : .label
        subView.backgroundColor = isAlreadySelected ? .mainColor : UIColor(named: "tabbar")
    }
    
    func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
        }
        
        subView.addSubview(imageView)
        imageView.snp_makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(40)
        }
    }
    
    func setData(title: String, imageTitle: String) {
        titleLabel.text = title
        imageView.image = UIImage(systemName: imageTitle)
    }
}
