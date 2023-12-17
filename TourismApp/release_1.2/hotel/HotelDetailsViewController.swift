//
//  HotelDetailsViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 04/12/23.
//

import UIKit

class HotelDetailsViewController: UIViewController {
    
    var hotel: HotelModel?
        
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: String.init(describing: CollectionViewTableViewCell.self))
        tableView.register(FacilitiesTableViewCell.self, forCellReuseIdentifier: String.init(describing: FacilitiesTableViewCell.self))
        tableView.register(HotelsDetailsTableViewCell.self, forCellReuseIdentifier: String.init(describing: HotelsDetailsTableViewCell.self))
        tableView.register(GoogleMapTableViewCell.self, forCellReuseIdentifier: String.init(describing: GoogleMapTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews() {
        title = hotel?.name
        view.backgroundColor = .systemBackground
        view.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        subView.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationController?.navigationBar.tintColor = .label
    }
}

extension HotelDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CollectionViewTableViewCell.self), for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
            
            if let photos = hotel?.photos {
                cell.imageURLs = photos
            }
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: HotelsDetailsTableViewCell.self), for: indexPath) as? HotelsDetailsTableViewCell else { return UITableViewCell() }
            if let hotel = hotel {
                cell.setData(hotel._id, hotel.name ?? "", hotel.city ?? "", hotel.description)
            }
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: GoogleMapTableViewCell.self), for: indexPath) as? GoogleMapTableViewCell else { return UITableViewCell() }
            
            if let hotel = hotel {
                cell.setMap(latitude: hotel.location?.latitude ?? Helper.getDefaultLocation().lat, longitude: hotel.location?.longitude ?? Helper.getDefaultLocation().lon, title: hotel.name ?? "", Snippet: hotel.city ?? "")
            }
            cell.setContactData(phoneNumber: hotel?.phone ?? "No available", website: hotel?.website ?? "No available")
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
