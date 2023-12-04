//
//  HotelViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 03/12/23.
//

import UIKit

class HotelViewController: UIViewController {
    
    var hotels = [HotelModel]() {
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
        tableView.register(HotelTableViewCell.self, forCellReuseIdentifier: String.init(describing: HotelTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 60, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        setupNavigation()
    }
    
    private func setupNavigation() {
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension HotelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: HotelTableViewCell.self), for: indexPath) as? HotelTableViewCell else { return UITableViewCell() }
        cell.setData(hotel: hotels[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}
