//
//  SearchResultsViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 01/01/24.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var searchResults: [SearchDestinationModel] = []
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(SuggestedTableViewCell.self, forCellReuseIdentifier: String.init(describing: SuggestedTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func initViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: SuggestedTableViewCell.self), for: indexPath) as? SuggestedTableViewCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.setData(with: searchResults[indexPath.row])
        return cell
    }
}

