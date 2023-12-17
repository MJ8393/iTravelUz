//
//  ExploreViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 09/09/23.
//

import UIKit
import AVKit

class ExploreViewController: BaseViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var destination: MainDestination?
    var city: City?
    var isCity = false
    var isLiked: Bool = false
    var thisWidth: CGFloat = CGFloat(UIScreen.main.bounds.width)
    var numberOfImages: Int = 0
    var isImageRecognition: Bool = false
    
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
        if isCity {
            numberOfImages = city?.gallery?.count ?? 1
        } else {
            numberOfImages = destination?.gallery?.count ?? 1
        }
        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        SpeechService.shared.speak(text: destionation?.description ?? "No description") {
        //        }
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupNavigation()
        tableView.tableHeaderView = collectionView
        navigationController?.navigationBar.barTintColor = .systemBackground
//        configurePageControl()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if isImageRecognition {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ExploreContentTableCell  {
            cell.stopSpeech()
        }
    }
    
    private func setupNavigation() {
        // Back button
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = {
            if self.isImageRecognition {
                self.dismiss(animated: true)
            }
            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if isCity {
            return
        }
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
                            self?.showAlert(title: "success".translate(), message: "\(self?.destination?.name?.getName() ?? "") " + "success_message_2".translate())
                        case .failure(let error):
                            print(error)
                            self?.showAlert(title: "fail".translate(), message: "\(self?.destination?.name?.getName() ?? "") " + "fail_message_2".translate())
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
                            self?.showAlert(title: "success".translate(), message: "\(self?.destination?.name?.getName() ?? "") " + "success_message_1".translate())
                        case .failure(let error):
                            print(error)
                            self?.showAlert(title: "fail".translate(), message: "\(self?.destination?.name?.getName() ?? "") " + "fail_message_1".translate())
                            likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                            likeButton.customButton.tintColor = UIColor.black
                        }
                    }
                }
            }
            self!.isLiked = !self!.isLiked
        }
        
        let reviewButton = CustomBarButtonView(image: UIImage(systemName: "square.and.pencil")!)
        reviewButton.buttonAction = { [weak self] in
            let vc = CommentsViewController()
            vc.destionation = self?.destination
            self?.presentPanModal(vc)
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: likeButton), UIBarButtonItem(customView: reviewButton)]
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
        
        subView.addSubview(pageControl)
        pageControl.snp_makeConstraints { make in
            make.centerX.equalTo(collectionView)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-5)
        }
    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCity {
            if let city = city {
                return 2
            }
        } else {
            if let destination = destination {
                return 2 + (destination.comments?.count ?? 0) + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ExploreContentTableCell.self), for: indexPath) as? ExploreContentTableCell else { return UITableViewCell() }
            if isCity {
                if let city = city {
                    cell.setData(city.name?.getName() ?? "No name", city.description?.getDescription() ?? "No description")
                }
            } else {
                if let destination = destination {
                    cell.setData(destination.name?.getName() ?? "No name", destination.description?.getDescription() ?? "No description")
                    if let tts = destination.tts {
                        cell.setTTS(tts: tts)
                    }
                }
            }
            cell.setLanguage()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MapTableViewCell.self), for: indexPath) as? MapTableViewCell else { return UITableViewCell() }
            if isCity {
                if let city = city, let location = city.location {
                    cell.setMap(latitude: location.latitude ?? Helper.getDefaultLocation().lat, longitude: location.longitude ?? Helper.getDefaultLocation().lon, title: city.name?.getName() ?? "", Snippet: city.country?.getCountry() ?? "")
                }
            } else {
                if let destionation = destination {
                    if let location = destionation.location {
                        cell.setMap(latitude: location.latitude ?? Helper.getDefaultLocation().lat, longitude: location.longitude ?? Helper.getDefaultLocation().lon, title: destionation.name?.getName() ?? "", Snippet: destionation.city_name?.getCityName() ?? "")
                    }
                }
            }
            
            cell.delegate = self
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        let defaultOffset = view.safeAreaInsets.top
        //        let offset = scrollView.contentOffset.y + defaultOffset
        //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//        if let collectionView = scrollView as? UITableView {
//            // It's a UICollectionView scrolling
//            let defaultOffset = view.safeAreaInsets.top
//            let offset = collectionView.contentOffset.y + defaultOffset
//            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//        } else {
//            // It's some other type of UIScrollView scrolling
//            // Handle it accordingly
//        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isCity {
            if let city = city, let gallery = city.gallery {
                return gallery.count
            }
        } else {
            if let destionation = destination, let gattery = destionation.gallery {
                return gattery.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderImagesCollectionViewCell.identifier, for: indexPath) as? HeaderImagesCollectionViewCell else { return UICollectionViewCell()}
        if isCity {
            if let city = city, let gallery = city.gallery {
                cell.setImage(with: gallery[indexPath.section])
            }
        } else {
            if let destionation = destination, let gattery = destionation.gallery {
                cell.setImage(with: gattery[indexPath.section].url ?? "destination_653a701b0ba11ced210daa73_5-0-0-0-0-1583403867-0-0-0-0-1583403914.jpg")
            }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
}

extension ExploreViewController: MapTableViewCellDelegate {
    func mapViewTapped() {
        let vc = InfoVC()
        if isCity {
            if let city = city {
                vc.city = city
                vc.isCity = true
            }
        } else {
            if let destination = destination {
                vc.destination = destination
                vc.isCity = false
            }
        }
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")!, style: .plain, target: self, action: #selector(dismissRegisterViewController))
        backButton.tintColor = .black

        navigationController?.navigationItem.leftBarButtonItem = backButton
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissRegisterViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension ExploreViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
