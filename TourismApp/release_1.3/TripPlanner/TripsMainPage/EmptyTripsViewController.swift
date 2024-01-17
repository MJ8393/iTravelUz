//
//  TripsViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/01/24.
//

import UIKit

protocol EmptyTripsViewControllerDelegate: AnyObject {
    func createWithAIButtonPressed()
}

class EmptyTripsViewController: BaseViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(EmptyTripsTableViewCell.self, forCellReuseIdentifier: String(describing: EmptyTripsTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func initViews() {
        title = "My Trips"
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension EmptyTripsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmptyTripsTableViewCell.self), for: indexPath) as? EmptyTripsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension EmptyTripsViewController: EmptyTripsViewControllerDelegate {
    func createWithAIButtonPressed() {
        let vc = PageViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navigationController, animated: true)
    }
}
