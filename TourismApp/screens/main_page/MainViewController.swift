//
//  MainViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 20/08/23.
//

import UIKit
import SnapKit
import CoreLocation


let titles = ["Nearest Places", "Cities", "Popular Destinations", "Cousines"]

class MainViewController: UIViewController {
    
    var nearbyDestinations = [MainDestination]()
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: String.init(describing: MainTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
    }()

    var avatarView: AccountView!
    var avatarTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initViews()
        
        // API
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
        header.imageView.image = UIImage(named: "Registan")!
        tableView.tableHeaderView = header
        setupNavigation()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
               navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: Get Nearby
    func getNearbyCities(lat: Double, long: Double) {
        API.shared.getNearbyPlace(lat: lat, long: long) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nearbyDestinations = data.destinations
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigation() {
        avatarView = AccountView()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: nil),
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarView)
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
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MainTableViewCell.self), for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.setData(destinations: nearbyDestinations)
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = SectionHeaderView()
        sectionHeader.delegate = self
        sectionHeader.setData(title: titles[section])
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension MainViewController: MainControllerDelegate {
    func didSelectItem(index: Int) {
        let vc = ExploreViewController()
        let destination = nearbyDestinations[index]
        vc.destionation = destination
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func viewAllTapped() {
        let vc = ViewAllVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .authorizedWhenInUse, .authorizedAlways:
               locationManager.startUpdatingLocation()
           case .denied, .restricted:
               getNearbyCities(lat: 41.2995, long: 69.2401)
           default:
               break
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                // Check if the location has changed significantly
                if let previousLocation = self.previousLocation {
                    if location.distance(from: previousLocation) > 10.0 {
                        getNearbyCities(lat: latitude, long: longitude) // Change 10.0 to your desired threshold in meters
                    }
                } else {
                    getNearbyCities(lat: latitude, long: longitude)
                }
                // Store the current location as the previous location
                self.previousLocation = location
                // Stop updating location if needed
                locationManager.stopUpdatingLocation()
            }
        }

}
