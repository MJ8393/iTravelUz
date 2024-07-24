//
//  ProductViewController.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 22/07/24.
//

import UIKit

class ProductViewController: UIViewController {

    var marketID: String?
    var products = [ProductModel]() // Assuming you have a ProductModel for your products

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var productLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    lazy var productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: productLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(productCollectionView)
        productCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadProducts()
    }

    private func loadProducts() {
        guard let marketID = marketID else { return }
        API().getProducts(for: marketID) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.productCollectionView.reloadData()
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
}

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.item]
        cell.configure(with: product) // Assuming you have a configure method
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 3 * 16) / 2
        return CGSize(width: itemWidth, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
}
