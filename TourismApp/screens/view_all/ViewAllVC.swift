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

    var destination: MainDestination?
    
    var lastOffset: CGFloat = 0.0
    
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
        
        let backButton = CustomBarButtonView(image: UIImage(systemName: "chevron.backward")!)
        backButton.buttonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -lastOffset))
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
            let city = cities[indexPath.row]
            cell.setCity(city: city)
//            destination = MainDestination(id: city.id, name: city.name, location: city.location, city_name: city.country, description: city.description, recommendationLevel: city.recommendationLevel, gallery: city.gallery, comments: city.comments)
        } else {
            let city = destionations[indexPath.row]
            cell.setData(destination: city)
            destination = MainDestination(id: city.id, name: city.name, location: city.location, city_name: city.city_name, description: city.description, recommendationLevel: city.recommendationLevel, gallery: city.gallery, comments: city.comments, tts: nil)
//            if let gallery = destionations[indexPath.row].gallery {
//                self.gallery[indexPath.row] = gallery[indexPath.row]
//            }
            
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
        if isCity {
            let vc = ExploreViewController()
            let destination = cities[indexPath.row]
            vc.city = destination
            vc.isCity = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ExploreViewController()
            let destination = destionations[indexPath.row]
            vc.destination = destination
            vc.isCity = false
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        lastOffset = offset
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension ViewAllVC: ViewAllVCDelegate {
    func locationButtonTapped() {
        let vc = InfoVC()
        vc.destination = destination
        navigationController?.pushViewController(vc, animated: true)
    }
}
