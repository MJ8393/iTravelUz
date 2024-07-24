//
//  BazarViewController.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 19/07/24.
//

import UIKit

class BazarViewController: UIViewController {

    var markets = [MarketModel]() {
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
        tableView.register(BazarTableViewCell.self, forCellReuseIdentifier: String.init(describing: BazarTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 110, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Guide me bazar"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initViews()
        setupNavigation()
        getData()
    }
    
    private func setupNavigation() {}
    
    private func getData() {
        API().getAllMarkets { [weak self] result in
            switch result {
            case .success(let markets):
                self?.markets = markets
            case .failure(let error):
                print("Failed to fetch markets: \(error)")
            }
        }
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(tableView)

        let topInset: CGFloat = (navigationController?.navigationBar.frame.height ?? 10) + 60
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topInset)
        }
    }
}

extension BazarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: BazarTableViewCell.self), for: indexPath) as? BazarTableViewCell else { return UITableViewCell() }
        
        let market = markets[indexPath.row]
        cell.setData(market: market)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let market = markets[indexPath.row]
        let productVC = ProductViewController()
        productVC.marketID = market.id
        navigationController?.pushViewController(productVC, animated: true)
    }
}
