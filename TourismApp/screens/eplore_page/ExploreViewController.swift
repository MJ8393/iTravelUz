//
//  ExploreViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 09/09/23.
//

import UIKit
import AVKit

class ExploreViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var destionation: MainDestination?
    var isLiked: Bool = false
    var thisWidth: CGFloat = CGFloat(UIScreen.main.bounds.width)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExploreContentTableCell.self, forCellReuseIdentifier: String.init(describing: ExploreContentTableCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: thisWidth, height: 240)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: thisWidth, height: 240), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.register(HeaderImagesCollectionViewCell.self, forCellWithReuseIdentifier: HeaderImagesCollectionViewCell.identifier)
        collectionView.addSubview(pageControl)
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .red
        return pageControl
    }()
    
    let synthesizer = AVSpeechSynthesizer()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        SpeechService.shared.speak(text: destionation?.description ?? "No description") {
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupNavigation()
//        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240))
//        header.imageView.image = UIImage(named: "Registan")!
//        header.addSwipeActions()
        tableView.tableHeaderView = collectionView
        configurePageControl()
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
    }
    
    private func setupNavigation() {
        // Back button
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // Like Button
        let likeButton = CustomBarButtonView(image: UIImage(systemName: "heart")!)
        if let favorites = UD.favorites, let destionation = destionation {
            if favorites.contains(destionation.id) {
                isLiked = true
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                likeButton.customButton.tintColor = UIColor.init(hex: "ED2B2A")
            } else {
                isLiked = false
                likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                likeButton.customButton.tintColor = UIColor.black
            }
        }
        
        
        likeButton.buttonAction = { [weak self] in
            if self!.isLiked {
                likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                likeButton.customButton.tintColor = UIColor.black
                if let id = self!.destionation?.id {
                    API.shared.removeFromFavorites(destionationID: id) { result in
                        switch result {
                        case .success(_):
                            self!.showAlert(title: "Success", message: "\(self!.destionation!.name) successfully removed from favorites")
                        case .failure(let error):
                            print(error)
                            self!.showAlert(title: "Failure", message: "\(self!.destionation!.name) could be removed from favorites")
                            likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                            likeButton.customButton.tintColor = UIColor.init(hex: "ED2B2A")
                        }
                    }
                }
            } else {
                Vibration.light.vibrate()
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                likeButton.customButton.tintColor = UIColor.init(hex: "ED2B2A")
                if let id = self!.destionation?.id {
                    API.shared.addToFavorites(destionationID: id) { result in
                        switch result {
                        case .success(_):
                            self!.showAlert(title: "Success", message: "\(self!.destionation!.name) successfully added to favorites")
                        case .failure(let error):
                            print(error)
                            self!.showAlert(title: "Failure", message: "\(self!.destionation!.name) could be added to favorites")
                            likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                            likeButton.customButton.tintColor = UIColor.black
                        }
                    }
                }
            }
            self!.isLiked = !self!.isLiked
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ExploreContentTableCell.self), for: indexPath) as? ExploreContentTableCell else { return UITableViewCell() }
//        if let destination = destionation {
//            cell.setData(destination.name, destination.description ?? "No description")
//        }
        cell.setData("", "")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
            let offset = scrollView.contentOffset.y + defaultOffset
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderImagesCollectionViewCell.identifier, for: indexPath) as? HeaderImagesCollectionViewCell else { return UICollectionViewCell()}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(UIScreen.main.bounds.width)
        return CGSize(width: thisWidth, height: 240)
    }
}
