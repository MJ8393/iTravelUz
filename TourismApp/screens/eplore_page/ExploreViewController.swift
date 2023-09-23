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
    
    let synthesizer = AVSpeechSynthesizer()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SpeechService.shared.speak(text: destionation?.description ?? "No description") {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupNavigation()
        
        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240))
        header.imageView.image = UIImage(named: "Registan")!
        tableView.tableHeaderView = header
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
        likeButton.buttonAction = { [weak self] in
            if self!.isLiked {
                likeButton.customButton.setImage(UIImage(systemName: "heart")!)
                likeButton.customButton.tintColor = UIColor.black
            } else {
                Vibration.light.vibrate()
                likeButton.customButton.setImage(UIImage(systemName: "heart.fill")!)
                likeButton.customButton.tintColor = UIColor.red
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
        if let destination = destionation {
            cell.setData(destination.name, destination.description ?? "No description")
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
