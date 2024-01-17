//
//  InterestsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 13/01/24.
//

import UIKit

class InterestsTableViewCell: UITableViewCell {
    
    let interestsOptions = ["Art & Culture", "Food & Drinks", "Nature", "Historical Sites", "Shopping", "Urban Areas", "Educational", "Relaxation"]
    let icons = ["paintbrush.pointed", "cup.and.saucer", "tree", "building.columns", "cart", "building.2", "book", "sun.max"]
    static var interests: [String] = []
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 12
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(InterestsCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: InterestsCollectionViewCell.self))
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
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(250)
            make.bottom.equalToSuperview()
        }
    }
}

extension InterestsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestsOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: InterestsCollectionViewCell.self), for: indexPath) as? InterestsCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(title: interestsOptions[indexPath.row], imageName: icons[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InterestsCollectionViewCell else { return }
        Vibration.light.vibrate()
        cell.updateCheckStatus()
        if cell.isAlreadySelected == true {
            InterestsTableViewCell.interests.append(interestsOptions[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30)/2, height: 60)
    }
}
