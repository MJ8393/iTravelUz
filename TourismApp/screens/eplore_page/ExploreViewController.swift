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
    
    var destination: MainDestination?
    var isLiked: Bool = false
    var thisWidth: CGFloat = CGFloat(UIScreen.main.bounds.width)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExploreContentTableCell.self, forCellReuseIdentifier: String.init(describing: ExploreContentTableCell.self))
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: String.init(describing: CommentsTableViewCell.self))
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: String.init(describing: MapTableViewCell.self))
        tableView.register(CommentsSmallTableViewCell.self, forCellReuseIdentifier: String.init(describing: CommentsSmallTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
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
        collectionView.showsHorizontalScrollIndicator = false
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
        if let favorites = UD.favorites, let destionation = destination {
            if favorites.contains(destionation.id) {
                isLiked = true
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                likeButton.customButton.tintColor =  UIColor.label
            } else {
                isLiked = false
                likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                likeButton.customButton.tintColor = UIColor.label
            }
        }
        
        
        likeButton.buttonAction = { [weak self] in
            if self!.isLiked {
                likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                likeButton.customButton.tintColor = UIColor.label
                if let id = self!.destination?.id {
                    API.shared.removeFromFavorites(destionationID: id) { result in
                        switch result {
                        case .success(_):
                            self!.showAlert(title: "Success", message: "\(self!.destination!.name?.getName() ?? "") successfully removed from favorites")
                        case .failure(let error):
                            print(error)
                            self!.showAlert(title: "Failure", message: "\(self!.destination!.name?.getName() ?? "") could be removed from favorites")
                            likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                            likeButton.customButton.tintColor = UIColor.label
                        }
                    }
                }
            } else {
                Vibration.light.vibrate()
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                likeButton.customButton.tintColor =  UIColor.label
                if let id = self!.destination?.id {
                    API.shared.addToFavorites(destionationID: id) { result in
                        switch result {
                        case .success(_):
                            self!.showAlert(title: "Success", message: "\(self!.destination!.name?.getName() ?? "") successfully added to favorites")
                        case .failure(let error):
                            print(error)
                            self!.showAlert(title: "Failure", message: "\(self!.destination!.name?.getName() ?? "") could be added to favorites")
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
        view.backgroundColor = UIColor.systemBackground
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
        if let destination = destination {
            return 2 + (destination.comments?.count ?? 0) + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ExploreContentTableCell.self), for: indexPath) as? ExploreContentTableCell else { return UITableViewCell() }
            if let destination = destination {
                cell.setData(destination.name?.getName() ?? "No name", destination.description?.getDescription() ?? "No description")
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MapTableViewCell.self), for: indexPath) as? MapTableViewCell else { return UITableViewCell() }
            if let destionation = destination {
                cell.setMap(latitude: destionation.location.latitude, longitude: destionation.location.latitude, title: destionation.name?.getName() ?? "", Snippet: destionation.city_name?.getCityName() ?? "")
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CommentsTableViewCell.self), for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
            if let destination = destination, let comments = destination.comments {
                cell.setCommands(count: comments.count)
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CommentsSmallTableViewCell.self), for: indexPath) as? CommentsSmallTableViewCell else { return UITableViewCell() }
            if let destination = destination, let comments = destination.comments {
                cell.setCommend(comments[indexPath.row - 3].text ?? "")
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1) {
            let vc = InfoVC()
            if let destination = destination, let cityLabelText = destination.name?.getName(), let cityName = destination.city_name?.getCityName(), let gallery = destination.gallery {
                vc.coordinate.latitude = destination.location.latitude
                vc.coordinate.longitude = destination.location.longitude
                vc.cityLabelText = cityLabelText
                vc.cityName = cityName
                vc.gallery = gallery
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        let defaultOffset = view.safeAreaInsets.top
        //        let offset = scrollView.contentOffset.y + defaultOffset
        //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        if let collectionView = scrollView as? UITableView {
            // It's a UICollectionView scrolling
            let defaultOffset = view.safeAreaInsets.top
            let offset = collectionView.contentOffset.y + defaultOffset
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        } else {
            // It's some other type of UIScrollView scrolling
            // Handle it accordingly
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let destionation = destination, let gattery = destionation.gallery {
            return gattery.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderImagesCollectionViewCell.identifier, for: indexPath) as? HeaderImagesCollectionViewCell else { return UICollectionViewCell()}
        if let destionation = destination, let gattery = destionation.gallery {
            cell.setImage(with: gattery[indexPath.section].url)
        }
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
