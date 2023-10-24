//
//  PersonalViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 21/10/23.
//

import UIKit

class PersonalViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var profile: ProfileInfo?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(PersonalTableViewCell.self, forCellReuseIdentifier: String.init(describing: PersonalTableViewCell.self))
        return tableView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "empty".translate()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = UD.username
        view.backgroundColor = UIColor.systemBackground
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

    func getPersonalInfo() {
        API.shared.getUserData { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed to get user data")
                print(error)
            }
        }
    }
}

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: PersonalTableViewCell.self), for: indexPath) as? PersonalTableViewCell else { return UITableViewCell() }
//        let destionations = profile.
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PersonalHeaderView()
        if let profile = profile {
            view.userNameLabel.text = profile.username ?? ""
            view.emailLabel.text = profile.email 
        }
        view.backgroundColor = .clear
        return view
    }
}
