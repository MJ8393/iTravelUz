//
//  BazarViewController.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 19/07/24.
//

import UIKit

class BazarViewController: UIViewController {

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
        tableView.reloadData()
        
    }
    
    private func setupNavigation() {
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(tableView)

        let topInset : CGFloat = (navigationController?.navigationBar.frame.height ?? 10) + 60
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topInset)
        }
    }
}

extension BazarViewController : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: BazarTableViewCell.self), for: indexPath) as? BazarTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
}
