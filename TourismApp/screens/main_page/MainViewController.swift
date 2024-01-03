//
//  MainViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 20/08/23.
//

import UIKit
import SnapKit
import CoreLocation


var titles = ["near_destinations".translate(), "cities".translate(), "popular_destinations".translate()]

class MainViewController: BaseViewController {
    
    var isSuccessfullyLoadedR1: Bool = false
    var isSuccessfullyLoadedR2: Bool = false
    var isSuccessfullyLoadedR3: Bool = false
    
    var isReloadPageOpened: Bool = false
    
    var longitude: CLLocationDegrees = 69.2401
    var latitude: CLLocationDegrees = 41.2995
    
    var nearbyDestinations = [MainDestination]()
    var cities = [City]()
    var popularDestionations = [MainDestination]()
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    
    var index = 0
    
    var images = [ UIImage(named: "bukhara")!, UIImage(named: "khiva")!, UIImage(named: "juma")!, UIImage(named: "nodira_begim")!]
    var titlesMain = ["poi_kalon".translate(), "khiva".translate(), "juma_mosque".translate(), "nadiragebim".translate()]
    
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
    
    let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
    
    var cityRequestFinished: Bool = false
    var popularRequestFinished: Bool = false
    var nearbyRequestFinished: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        //        self.navigationController?.navigationBar.tintColor = UIColor.mainColor
        initViews()
        isSuccessfullyLoadedR1 = false
        isSuccessfullyLoadedR2 = false
        isSuccessfullyLoadedR3 = false
        
        
        // API
        showLoadingView()
        getCities()
        getPopular()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //        header.imageView.image = UIImage(named: "Registan")!
        self.header.updateImageWithAnimation(images[0], titlesMain[0])
        tableView.tableHeaderView = header
        setupNavigation()
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //         navigationController?.navigationBar.barTintColor = UIColor.mainColor
        //
        
        performTaskWithTimer()
        NetworkMonitor.shared.delegate = self
    }
    
    func performTaskWithTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.index += 1
            if self.index >= self.images.count {
                self.index = 0
            }
            let image = self.images[self.index]
            let title = self.titlesMain[self.index]
            self.header.updateImageWithAnimation(image, title)
        }
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        titles = ["near_destinations".translate(), "cities".translate(), "popular_destinations".translate()]
        tableView.reloadData()
        titlesMain = ["poi_kalon".translate(), "juma_mosque".translate(), "nadiragebim".translate(), "shoxizinda".translate(), "khiva".translate()]
        //        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        stopMonitoring()
    }
    
    // MARK: Get Nearby
    func getNearbyCities(lat: Double, long: Double) {
        nearbyRequestFinished = false
        API.shared.getNearbyPlace(lat: lat, long: long) { [weak self] result in
            self?.nearbyRequestFinished = true
            self?.hideLoader()
            switch result {
            case .success(let data):
                self?.nearbyDestinations = data.destinations
                self?.tableView.reloadData()
                self?.isSuccessfullyLoadedR1 = true
            case .failure(let error):
                self?.isSuccessfullyLoadedR1 = false
                print(error)
            }
        }
    }
    
    func getCities() {
        cityRequestFinished = false
        API.shared.getMainCities { [weak self] result in
            self?.cityRequestFinished = true
            self?.hideLoader()
            switch result {
            case .success(let data):
                if let cities = data.cities {
                    self?.cities = cities
                    self?.tableView.reloadData()
                    self?.isSuccessfullyLoadedR2 = true
                }
            case .failure(let error):
                print(error)
                self?.isSuccessfullyLoadedR2 = false
            }
        }
    }
    
    func getPopular() {
        popularRequestFinished = false
        API.shared.getPopularCities { [weak self] result in
            self?.popularRequestFinished = true
            self?.hideLoader()
            switch result {
            case .success(let data):
                self?.popularDestionations = data.destinations
                self?.tableView.reloadData()
                self?.isSuccessfullyLoadedR3 = true
            case .failure(let error):
                self?.isSuccessfullyLoadedR3 = false
                print(error)
            }
        }
    }
    
    func hideLoader() {
        if popularRequestFinished && cityRequestFinished && nearbyRequestFinished {
            self.dissmissLoadingView()
        }
    }
    
    
    private func setupNavigation() {
        //        avatarView = AccountView()
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped))
        //        avatarView.addGestureRecognizer(gesture)
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarView)
    }
    
    @objc func avatarViewTapped() {
        let vc = PersonalViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MainTableViewCell.self), for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.setData(destinations: nearbyDestinations)
            cell.sectionIndex = 0
        } else if indexPath.section == 1 {
            cell.setCity(cities: cities)
            cell.sectionIndex = 1
        } else if indexPath.section == 2 {
            cell.setData(destinations: popularDestionations)
            cell.sectionIndex = 2
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = SectionHeaderView()
        sectionHeader.index = section
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
        //        let defaultOffset = view.safeAreaInsets.top
        //        let offset = scrollView.contentOffset.y + defaultOffset
        //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
        
        if scrollView.contentOffset.y < -150 {
            Vibration.light.vibrate()
            let vc = ExploreViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: MainControllerDelegate {
    func didSelectItem(index: Int, section: Int) {
        if section == 0 {
            let vc = ExploreViewController()
            let destination = nearbyDestinations[index]
            vc.destination = destination
            vc.isCity = false
            navigationController?.pushViewController(vc, animated: true)
        } else if section == 1 {
            let vc = ExploreViewController()
            let destination = cities[index]
            vc.city = destination
            vc.isCity = true
            navigationController?.pushViewController(vc, animated: true)
        } else if section == 2 {
            let vc = ExploreViewController()
            let destination = popularDestionations[index]
            vc.destination = destination
            vc.isCity = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func viewAllTapped(index: Int) {
        let vc = ViewAllVC()
        if index == 0 {
            vc.destionations = nearbyDestinations
            vc.isCity = false
            vc.title = titles[0]
        } else if index == 1 {
            vc.cities = cities
            vc.isCity = true
            vc.title = titles[1]
        } else if index == 2 {
            vc.destionations = popularDestionations
            vc.isCity = false
            vc.title = titles[2]
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            longitude = 41.2995
            latitude = 69.2401
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
                    self.longitude = latitude
                    self.latitude = longitude
                    getNearbyCities(lat: latitude, long: longitude) // Change 10.0 to your desired threshold in meters
                }
            } else {
                self.longitude = latitude
                self.latitude = longitude
                getNearbyCities(lat: latitude, long: longitude)
            }
            // Store the current location as the previous location
            self.previousLocation = location
            // Stop updating location if needed
            locationManager.stopUpdatingLocation()
        }
    }
    
}

extension MainViewController: NetworkMonitorDelegate {
    func checkInternetConnection(isOnline: Bool) {
        if !isOnline && !isSuccessfullyLoadedR1 && !isSuccessfullyLoadedR2 && !isSuccessfullyLoadedR3 && !isReloadPageOpened {
            let vc = NoInternetViewController()
            vc.noInternetView.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            Vibration.heavy.vibrate()
            self.present(vc, animated: true)
            isReloadPageOpened = true
        }
        
        if isOnline && isReloadPageOpened {
            self.dismiss(animated: true)
            isReloadPageOpened = false
            showLoadingView()
            getCities()
            getPopular()
            getNearbyCities(lat: latitude, long: longitude)
        }
    }
}

extension MainViewController: NoInternetViewDelegate {
    func reloadTapped() {
        isReloadPageOpened = false
        self.dismiss(animated: true)
        showLoadingView()
        getCities()
        getPopular()
        getNearbyCities(lat: latitude, long: longitude)
    }
}
