//
//  EatsTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 16/12/23.
//

import UIKit

class EatsTableViewCell: UITableViewCell {
    
    var eats: [String] = ["Shashlik", "Manti", "Sho'rva", "Somsa", "Palov"]
    
    var width = UIScreen.main.bounds.width - 10 - 10
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.isScrollEnabled = false
        collectionView.layer.cornerRadius = 12
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EatsCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: EatsCollectionViewCell.self))
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func initViews() {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(200)
        }
    }
}

extension EatsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: EatsCollectionViewCell.self), for: indexPath) as? EatsCollectionViewCell else { return UICollectionViewCell() }
        
//        cell.setData("", eats[indexPath.row])
//        cell
        return cell
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 190)
    }
}
