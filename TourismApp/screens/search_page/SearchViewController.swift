//
//  SearchViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 29/12/23.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func discoverSampleTapped(with index: Int)
}

class SearchViewController: BaseViewController {
    
    var sectionTitles: [String] = ["discover".translate(), "suggested".translate()]
    var discoverTitles = ["Tashkent TV Tower", "Ark of Bukhara", "Kukeldash madrasah", "Registan Square", "Lyabi-Hauz ensemble", "Miri Arab Madrasah"]
    var isLoading: Bool = false
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 9, y: 9, width: 17, height: 17))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass")
        return imageView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "search_place".translate()
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: String.init(describing: DiscoverTableViewCell.self))
        tableView.register(SuggestedTableViewCell.self, forCellReuseIdentifier: String.init(describing: SuggestedTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        title = "search".translate()
        sectionTitles = ["discover".translate(), "suggested".translate()]
        searchController.searchBar.placeholder = "search_place".translate()
        navigationItem.searchController?.searchBar.setValue("cancel".translate(), forKey: "cancelButtonText")
        tableView.reloadData()
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        resultsController.tableView.reloadData()
    }
    
    private func initViews() {
        title = "search".translate()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.setValue("cancel".translate(), forKey: "cancelButtonText")
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: DiscoverTableViewCell.self), for: indexPath) as? DiscoverTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.discoverTitles = discoverTitles
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: SuggestedTableViewCell.self), for: indexPath) as? SuggestedTableViewCell else {return UITableViewCell()}
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: view.bounds.origin.x + 20, y: view.bounds.origin.y, width: 100, height: view.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.isEmpty, 
                let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        if isLoading {
            self.dissmissLoadingView()
        }
        showLoadingView()
        isLoading = true
        
        API.shared.searchDestination(name: query) { [weak self] result in
            if self?.isLoading != false {
                self?.dissmissLoadingView()
                self?.isLoading = false
            }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    resultsController.searchResults = data.destinations
                    resultsController.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    func discoverSampleTapped(with index: Int) {
        searchController.isActive = true
        
        if isLoading {
            self.dissmissLoadingView()
        }
        showLoadingView()
        isLoading = true
        
        if isLoading != false {
            searchController.searchBar.text = discoverTitles[index]
            searchController.automaticallyShowsSearchResultsController = true
            dissmissLoadingView()
            isLoading = false
        }
    }
}
