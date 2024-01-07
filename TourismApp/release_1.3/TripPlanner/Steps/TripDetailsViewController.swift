//
//  TripDetailsViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
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
        tableView.backgroundColor = .clear
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: String(describing: CollectionViewTableViewCell.self))
        tableView.register(HeaderTitleTableViewCell.self, forCellReuseIdentifier: String(describing: HeaderTitleTableViewCell.self))
        tableView.register(DayTripTableViewCell.self, forCellReuseIdentifier: String(describing: DayTripTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    @objc func saveButtonPressed() {
        
    }
    
    private func initViews() {
        for _ in 0...4 {
            eachCellStatus.append(false)
        }
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(saveButtonPressed))
        saveButton.tintColor = .mainColor
        navigationItem.rightBarButtonItem = saveButton
        
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

extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollectionViewTableViewCell.self), for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 || indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTitleTableViewCell.self), for: indexPath) as? HeaderTitleTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if indexPath.row == 2 {
                cell.setData(title: "Day 1", description: "")
                cell.separatorLineView.isHidden = true
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DayTripTableViewCell.self), for: indexPath) as? DayTripTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.descriptionLabel.isHidden = eachCellStatus[indexPath.row - 3]
            cell.onArrowClick = { view in
                cell.containerView = view
                self.eachCellStatus[indexPath.row - 3].toggle()
                cell.updateArrowImage(expandStatus: self.eachCellStatus[indexPath.row - 3])
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


