//
//  RestaurantDetailViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 16/12/23.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    var restaurant: RestaurantModel?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: String.init(describing: HeaderTableViewCell.self))
        tableView.register(EatsTableViewCell.self, forCellReuseIdentifier: String.init(describing: EatsTableViewCell.self))
        tableView.register(GoogleMapTableViewCell.self, forCellReuseIdentifier: String.init(describing: GoogleMapTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = restaurant?.name
        initViews()
        if let meals = restaurant?.meals {
            print(Int(meals.count / 2))
        }
    }
    
    func initViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(subView)
        subView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        subView.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RestaurantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: HeaderTableViewCell.self), for: indexPath) as? HeaderTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
    
            if let restaurant = restaurant, let city = restaurant.city, let to = restaurant.workingHours?.to, let from = restaurant.workingHours?.from, let photos = restaurant.photos {
                cell.setData(restaurant._id, restaurant.name, city, from + " - " + to)
                cell.imageURLs = photos
            }
            
            return cell
        } else if(indexPath.row == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: EatsTableViewCell.self), for: indexPath) as? EatsTableViewCell else { return UITableViewCell() }
            if let restaurant = restaurant, let meals = restaurant.meals {
                cell.meals = meals
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
//            if let meals = restaurant?.meals {
//                cell.eats = meals
//            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: GoogleMapTableViewCell.self), for: indexPath) as? GoogleMapTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setContactData(phoneNumber: restaurant?.phone?[0] ?? "", website: "")
            
            cell.setMap(latitude: restaurant?.location?.latitude ?? Helper.getDefaultLocation().lat, longitude: restaurant?.location?.longitude ?? Helper.getDefaultLocation().lon, title: restaurant?.name ?? "", Snippet: restaurant?.city ?? "")
            
            return cell
        }
    }
}

extension RestaurantDetailViewController: GoogleMapTableViewCellDelegate2 {
    func mapViewTapped() {
        return
    }
}
