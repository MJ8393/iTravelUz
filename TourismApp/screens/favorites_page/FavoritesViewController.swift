//
//  FavoritesViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/09/23.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    var favoriteDestinations = [MainDestination]()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "empty".translate()
        label.textColor = .label
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: String.init(describing: FavoritesTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
//        tableView.dragDelegate = self
//        tableView.dragInteractionEnabled = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        title = "favorites".translate()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorites()
    }
    
    func getFavorites() {
        API.shared.getFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let destinations = data.favorites {
                    self.favoriteDestinations = destinations
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "favorites".translate()
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: FavoritesTableViewCell.self), for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        cell.setData(destionation: favoriteDestinations[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.favoriteDestinations.count
        if count == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let customAction = UIContextualAction(style: .normal, title: "delete".translate()) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            API.shared.removeFromFavorites(destionationID: self.favoriteDestinations[indexPath.row].id) { result in
                switch result {
                case .success(_):
                    self.favoriteDestinations.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                case .failure(let error):
                    print(error)
                }
            }
            completionHandler(true)
        }
        // Set your custom image
        customAction.image = UIImage(systemName: "trash.fill")
        
        // Set your custom background color (optional)
        customAction.backgroundColor = UIColor.init(hex: "ED2B2A")
        
        let configuration = UISwipeActionsConfiguration(actions: [customAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
//        dragItem.localObject = data[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let mover = data.remove(at: sourceIndexPath.row)
//        data.insert(mover, at: destinationIndexPath.row)
    }
    
}
