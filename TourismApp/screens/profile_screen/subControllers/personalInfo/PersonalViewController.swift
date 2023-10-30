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
        label.isHidden = true
        return label
    }()
    
    private let deleteAccount: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.layer.cornerRadius = 16
        registerButton.backgroundColor = .label
        registerButton.setTitle("delete_account".translate(), for: .normal)
        registerButton.tintColor = .systemBackground
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        registerButton.addTarget(self, action: #selector(deleteAccountTarget), for: .touchUpInside)
        return registerButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "my_info".translate()
        view.backgroundColor = UIColor.systemBackground
        initViews()
        getPersonalInfo()
    }
    
    
    @objc func deleteAccountTarget() {
        showCustomAlert()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subView.addSubview(deleteAccount)
        deleteAccount.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-getBottomMargin() - 20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(deleteAccount.snp.top)
        }
    }
    
    func showCustomAlert() {
        let alertController = UIAlertController(title: "delete_account".translate(), message: "are_you_sure".translate(), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "delete".translate(), style: .destructive) { (action) in
            self.performDeleteAction()
        }
        
        let cancelAction = UIAlertAction(title: "calcel".translate(), style: .cancel) { (action) in
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func performDeleteAction() {
        API.shared.deleteUser { result in
            switch result {
            case .success(_):
                UD.token = ""
                UD.username = ""
                self.goLoginPage()
            case .failure(_):
                self.showAlert(title: "Error", message: "Can not delete account.")
            }
        }
    }

    func getPersonalInfo() {
        showLoadingView()
        API.shared.getUserData { [weak self] result in
            self?.dissmissLoadingView()
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed to get user data")
                print(error)
            }
        }
    }
}

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let profile = profile, let destionations = profile.comments {
            emptyLabel.isHidden = true
            return destionations.count
        }
        emptyLabel.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: PersonalTableViewCell.self), for: indexPath) as? PersonalTableViewCell else { return UITableViewCell() }
        if let profile = profile, let destionations = profile.comments {
            cell.userID = profile.user_id ?? ""
            cell.setData(destionation: destionations[indexPath.row])
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PersonalHeaderView()
        if let profile = profile {
            view.userNameLabel.text = profile.username ?? "Username"
            view.emailLabel.text = profile.email ?? "Email"
        }
        if let profile = profile, let destionations = profile.comments {
            if destionations.count == 0 {
                view.titleLabel.isHidden = true
            } else {
                view.titleLabel.isHidden = false
            }
        }
        view.backgroundColor = .clear
        return view
    }
}
