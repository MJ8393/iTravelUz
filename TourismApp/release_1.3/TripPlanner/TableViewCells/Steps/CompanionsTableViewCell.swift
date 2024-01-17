//
//  CompanionsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class CompanionsTableViewCell: UITableViewCell {
    
    let companions = ["Just me", "Couple", "Family", "Friends"]
    let icons = ["person", "heart", "figure.2.and.child.holdinghands", "figure.2"]
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 12
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(CompanionsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CompanionsCollectionViewCell.self))
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
    }
}

extension CompanionsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CompanionsCollectionViewCell.self), for: indexPath) as? CompanionsCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(title: companions[indexPath.row], imageTitle: icons[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...3 {
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: indexPath.section)) as? CompanionsCollectionViewCell {
                cell.isAlreadySelected = false
                cell.updateCheckStatus()
            }
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CompanionsCollectionViewCell else { return }
        Vibration.light.vibrate()
        cell.isAlreadySelected.toggle()
        cell.updateCheckStatus()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 50) / 2, height: 140)
    }
}
