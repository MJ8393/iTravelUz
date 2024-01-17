//
//  BudgetViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class BudgetViewController: UIViewController {
    
    let budgetTypes = ["Very Low", "Low", "Mid-Range", "Standard", "Luxury"]
    let priceLevels = ["Lower than $200", "$200-500", "$500-1000", "$1000-2000", "Higher than $2000"]
    let budgets = [150, 400, 800, 1500, 2500]
    static var budget: Int = 400
    
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
        tableView.register(BudgetTableViewCell.self, forCellReuseIdentifier: String(describing: BudgetTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    private func initViews() {
        
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
        return 6
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BudgetTableViewCell.self), for: indexPath) as? BudgetTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.setData(title: budgetTypes[indexPath.row - 1], price: priceLevels[indexPath.row - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            for i in 1...5 {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? BudgetTableViewCell {
                    cell.isAlreadySelected = false
                    cell.updateCheckStatus()
                }
            }
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? BudgetTableViewCell else { return }
            Vibration.light.vibrate()
            cell.isAlreadySelected.toggle()
            cell.updateCheckStatus()
            if cell.isAlreadySelected {
                BudgetViewController.budget = budgets[indexPath.row - 1]
            }
            NotificationCenter.default.post(name: .didSelectBudget, object: nil, userInfo: ["didChooseBudget": true])
        }
    }
}
