//
//  TripDetailsViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    var eachCellStatus: [Bool] = []
    var destinations = [[MainDestination]]()
    var restaurants = [RestaurantModel]()
    var hotels = [HotelModel]()
    var destinationsPerDay: Int = 0
    var restaurantsPerDay: Int = 0
    var hotelsPerDay: Int = 0
    
    let city = SearchPlaceViewController.city
    let startDate = StartDateTableViewCell.date
    let tripLength = TripLengthTableViewCell.tripLength
    let budget = BudgetViewController.budget
    let interests = InterestsTableViewCell.interests
    
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
        tableView.register(TripDescriptionTableViewCell.self, forCellReuseIdentifier: String(describing: TripDescriptionTableViewCell.self))
        tableView.register(DayTripTableViewCell.self, forCellReuseIdentifier: String(describing: DayTripTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planTrip()
    }
    
    @objc func backBtnPressed() {
        dismiss(animated: true)
    }
    
    @objc func saveBtnPressed() {
        
    }
    
    func planTrip() {
        if let cityName = city?.name?.getName() {
            showLoadingView()
            API.shared.planTrip(model: TripPlannerModel(CityName: cityName, StartDate: startDate, daysLength: tripLength, budget: budget, interests: interests)) { [weak self] result in
                self?.dissmissLoadingView()
                switch result {
                case .success(let data):
                    self?.destinations = data.destinations
                    if let restaurants = data.restaurants, let hotels = data.hotels {
                        self?.restaurants = restaurants
                        self?.hotels = hotels
                    }
                    self?.destinationsPerDay = data.number_of_destinations_per_day
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            dissmissLoadingView()
        }
    }
    
    private func initViews() {
        view.backgroundColor = .systemBackground
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtnPressed))
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(saveBtnPressed))
        saveButton.tintColor = .label
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
    
    func headerString(section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            if let cityName = city?.name?.getName(), let countryName = city?.country?.getCountry() {
                return "\(cityName), " + "\(countryName)"
            } else {
                return ""
            }
        } else {
            return "Day " + "\(section - 1)"
        }
    }
}

extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + tripLength
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            restaurantsPerDay = restaurants.count > 0 ? 1 : 0
            hotelsPerDay = hotels.count > 0 ? 1 : 0
            let dailyPlaces = destinationsPerDay + restaurantsPerDay + hotelsPerDay
            for _ in 0...dailyPlaces {
                eachCellStatus.append(false)
            }
            return dailyPlaces
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollectionViewTableViewCell.self), for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if let gallery = city?.gallery {
                cell.imageURLs = gallery
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TripDescriptionTableViewCell.self), for: indexPath) as? TripDescriptionTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if let description = city?.description?.getDescription() {
                cell.setData(description: description)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DayTripTableViewCell.self), for: indexPath) as? DayTripTableViewCell else { return UITableViewCell() }
            
            if indexPath.row == destinationsPerDay {
                let index = indexPath.section - 2 < restaurants.count ? indexPath.section - 2 : 0
                let restaurant = restaurants[index]
                cell.setRestaurant(model: RestaurantModel(_id: restaurant._id, name: restaurant.name, location: restaurant.location, city: restaurant.city, meals: restaurant.meals, workingHours: restaurant.workingHours, photos: restaurant.photos, phone: restaurant.phone), orderNumber: indexPath.row + 1)
            } else if indexPath.row == destinationsPerDay + 1 {
                let index = indexPath.section - 2 < hotels.count ? indexPath.section - 2 : 0
                let hotel = hotels[index]
                cell.setHotel(model: HotelModel(_id: hotel._id, name: hotel.name, description: hotel.description, location: hotel.location, star: hotel.star, city: hotel.city, photos: hotel.photos, mostPopularFacilities: hotel.mostPopularFacilities, phone: hotel.phone, website: hotel.website, email: hotel.email), orderNumber: indexPath.row + 1)
            } else {
                let destination = destinations[indexPath.section - 2][indexPath.row]
                cell.setDestination(model: MainDestination(id: destination.id, name: destination.name, location: destination.location, city_name: destination.city_name, description: destination.description, recommendationLevel: destination.recommendationLevel, gallery: destination.gallery, comments: destination.comments, tts: destination.tts), orderNumber: indexPath.row + 1)
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.descriptionLabel.isHidden = eachCellStatus[indexPath.row]
            cell.onArrowClick = { view in
                cell.containerView = view
                self.eachCellStatus[indexPath.row].toggle()
                cell.updateArrowImage(expandStatus: self.eachCellStatus[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeader()
        if let headerString = headerString(section: section) {
            header.setData(title: headerString)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}


