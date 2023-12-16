//
//  RestaurantViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 03/12/23.
//

import UIKit

protocol RestaurantViewControllerDelegate: AnyObject {
    func restaurantTapped(index: Int)
}

class RestaurantViewController: UIViewController {
    
    weak var delegate: RestaurantViewControllerDelegate?
    
    var restaurants = [RestaurantModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: String.init(describing: RestaurantTableViewCell.self))
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 60, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
    }
    
    private func initViews() {
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

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: RestaurantTableViewCell.self), for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        cell.setData(model: restaurants[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.restaurantTapped(index: indexPath.row)
    }
}
