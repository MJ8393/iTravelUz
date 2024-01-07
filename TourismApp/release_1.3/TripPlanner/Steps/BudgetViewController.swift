//
//  BudgetViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class BudgetViewController: UIViewController {

    var budgetTypes = ["Cheap", "Moderate", "Luxury"]
    var eachCellStatus: [Bool] = []
    
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
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: String(describing: TitleTableViewCell.self))
        tableView.register(InterestsTableViewCell.self, forCellReuseIdentifier: String(describing: InterestsTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    private func initViews() {
        for _ in 1...3 {
            eachCellStatus.append(false)
        }
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension BudgetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleTableViewCell.self), for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.titleLabel.text = "Budget"
            cell.descriptionLabel.text = "Choose spending habits for your trip"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InterestsTableViewCell.self), for: indexPath) as? InterestsTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.isInterest = false
            cell.setData(title: budgetTypes[indexPath.row - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? InterestsTableViewCell
        cell?.updateCheckStatus()
    }
}
