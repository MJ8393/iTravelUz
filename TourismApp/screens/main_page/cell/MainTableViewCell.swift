//
//  MainTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 20/08/23.
//

import UIKit

protocol MainControllerDelegate: AnyObject {
    func didSelectItem(index: Int, section: Int)
    func viewAllTapped(index: Int)
}

class MainTableViewCell: UITableViewCell {
    
    weak var delegate: MainControllerDelegate?
    
    var destinations = [MainDestination]()
    
    var isCity: Bool = false
    
    var sectionIndex: Int = 0
    
    var cities = [City]()

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 220, height: 260)
        flowLayout.minimumLineSpacing = 15
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MainCollectionView.self, forCellWithReuseIdentifier: String.init(describing: MainCollectionView.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        
        subView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(destinations: [MainDestination]) {
        self.destinations = destinations
        collectionView.reloadData()
        isCity = false
    }
    
    func setCity(cities: [City]) {
        self.cities = cities
        collectionView.reloadData()
        isCity = true
    }
    
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCity {
            return cities.count
        }
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainCollectionView.self), for: indexPath) as? MainCollectionView else { return UICollectionViewCell() }
        if isCity {
            cell.setCity(city: cities[indexPath.row])
        } else {
            cell.setData(destination: destinations[indexPath.row])
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(index: indexPath.row, section: sectionIndex)
    }
}
