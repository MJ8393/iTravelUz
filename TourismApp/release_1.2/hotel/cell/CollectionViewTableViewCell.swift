//
//  MainImageViewTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 04/12/23.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    var imageURLs: [String] = []
    var width = UIScreen.main.bounds.width - 10 - 10
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.tintColor = .green
        pageControl.backgroundColor = .red
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .blue
        pageControl.currentPageIndicatorTintColor = .brown
        return pageControl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.layer.cornerRadius = 6
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainImagesCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: MainImagesCollectionViewCell.self))
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
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(200)
        }
        
        subView.addSubview(pageControl)
        pageControl.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainImagesCollectionViewCell.self), for: indexPath) as? MainImagesCollectionViewCell else {return UICollectionViewCell()}
        cell.setImage(with: imageURLs[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: 200)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
}