//
//  ViewAllVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 10/09/23.
//

import UIKit

protocol ViewAllVCDelegate: AnyObject {
    func locationButtonTapped()
}

class ViewAllVC: UIViewController {
    
    var latitude: Double?
    var longitude: Double?
    var gallery: [Gallery] = []
    
    lazy var viewAllTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.frame = view.bounds
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    var destionations = [MainDestination]()
    var isCity: Bool = false
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(viewAllTableView)
        //self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor(named: "view_all_colorSet")
    }
}

extension ViewAllVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCity {
            return cities.count
        }
        return destionations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if isCity {
            cell.setCity(city: cities[indexPath.row])
        } else {
            cell.setData(destination: destionations[indexPath.row])
            self.latitude = destionations[indexPath.row].location.latitude
            self.longitude = destionations[indexPath.row].location.longitude
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension ViewAllVC: ViewAllVCDelegate {
    func locationButtonTapped() {
        let vc = InfoVC()
        guard let latitude = latitude, let longitude = longitude else { return }
        vc.coordinate.latitude = latitude
        vc.coordinate.longitude = longitude
        vc.gallery = gallery
        navigationController?.pushViewController(vc, animated: true)
    }
}
