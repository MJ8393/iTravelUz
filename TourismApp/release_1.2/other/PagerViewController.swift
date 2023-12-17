//
//  PagerViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 03/12/23.
//

import UIKit

let flightFilterData = ["All", "Flights inside Uzbekistan", "International Flights"]


class PagerController: DTPagerController {
    
    var is1RequestFinished: Bool = true
    var is2RequestFinished: Bool = true

    
    let viewController1 = HotelViewController()
    let viewController2 = RestaurantViewController()
    let viewController3 = FlightViewController()
    
    var hotelFilterData = [String]()
    var restaurantFilterData = [String]()
    var flightFilter = flightFilterData
    
    var restaurant = [RestaurantModel]()
    var hotels = [HotelModel]()
    
    var isFilterTapped: Bool = false

    
    init() {
        super.init(viewControllers: [])
        title = "Explore"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if UD.filterFlights == nil || UD.filterRestaurant == "" {
            UD.filterFlights = "All"
        }
        
        if UD.filterHotel == nil || UD.filterHotel == "" {
            UD.filterFlights = "All"
        }
        
        if UD.filterRestaurant == nil || UD.filterRestaurant == "" {
            UD.filterFlights = "All"
        }
                
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: #selector(filterTapped))
        rightBarButtonItem.tintColor = .label
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label

        perferredScrollIndicatorHeight = 2.0
        
        viewController1.title = "hotels".translate()
        viewController2.title = "restaurants".translate()
        viewController2.delegate = self
        viewController1.delegate = self
        viewController3.title = "flights".translate()
        viewControllers = [viewController1, viewController2, viewController3]
        scrollIndicator.backgroundColor = UIColor.mainColor
        scrollIndicator.layer.cornerRadius = 0
        setSelectedPageIndex(0, animated: false)
        textColor = UIColor.black
        pageScrollView.backgroundColor = .clear
        pageSegmentedControl.backgroundColor = .clear
        pageSegmentedControl.tintColor = .clear
        
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        getAllHotels()
        getAllRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFilterTapped = false
        title = "explore".translate()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isFilterTapped {
            title = ""
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
 
    @objc func filterTapped() {
        let vc = FilterViewController()
        vc.delegate = self
        if currentIndeX == 0 {
            vc.cities = hotelFilterData
            vc.filterType = .hotel
        } else if currentIndeX == 1 {
            vc.cities = restaurantFilterData
            vc.filterType = .restaurant
        } else if currentIndeX == 2 {
            vc.filterType = .flight
            vc.cities = flightFilter
        }
        isFilterTapped = true
        navigationController?.presentPanModal(vc)
    }
    
    func getAllHotels() {
        hotelFilterData = []
        hotels = []
        hotelFilterData.append("All")
        is1RequestFinished = false
        checkRequests()
        API.shared.getAllHotels { [weak self] result in
            self?.is1RequestFinished = true
            self?.checkRequests()
            switch result {
            case .success(let hotels):
                self?.hotels = hotels
                self?.viewController1.hotels = hotels
                for hotel in hotels {
                    if let city = hotel.city, let hotelFilterData1 = self?.hotelFilterData {
                        if !hotelFilterData1.contains(city) {
                            self?.hotelFilterData.append(city)
                        }
                    }
                }
            case .failure(_):
                self?.showAlert(title: "Error", message: "Please, Failure to get hotels")
            }
        }
    }
    
    func getAllRestaurants() {
        restaurantFilterData = []
        restaurant = []
        restaurantFilterData.append("All")
        is2RequestFinished = false
        checkRequests()
        API.shared.getAllRestaurant { [weak self] result in
            self?.is2RequestFinished = true
            self?.checkRequests()
            switch result {
            case .success(let restaurants):
                self?.restaurant = restaurants
                self?.viewController2.restaurants = restaurants
                for hotel in restaurants {
                    if let city = hotel.city, let resutrants = self?.restaurantFilterData {
                        if !resutrants.contains(city) {
                            self?.restaurantFilterData.append(city)
                        }
                    }
                }
            case .failure(let error):
                print("xx", error)
            }
        }
    }
    
    var isLoadingView: Bool = false
    
    func checkRequests() {
        if is1RequestFinished == false || is1RequestFinished == false {
            if !isLoadingView {
                self.showLoadingView()
            }
            isLoadingView = true
        }
        
        if is1RequestFinished == true && is1RequestFinished == true {
            self.dissmissLoadingView()
            isLoadingView = false
        }
        
    }
}

extension PagerController: RestaurantViewControllerDelegate {
    func restaurantTapped(index: Int) {
        let vc = RestaurantDetailViewController()
        vc.restaurant = restaurant[index]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PagerController: HotelViewControllerDelegate {
    func hotelTapped(index: Int) {
        let vc = HotelDetailsViewController()
        vc.hotel = hotels[index]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PagerController: FilterViewControllerDelegate {
    func indexTapped(_ index: Int, _ type: FilterType) {
        switch type {
        case .flight:
            if flightFilter[index] == "All" {
                viewController3.firstFlights = uzbekistanFlights
                viewController3.secondFlights = internationalFlights
                viewController3.numberOfSection = 2
            } else if flightFilter[index] == "Flights inside Uzbekistan" {
                viewController3.firstFlights = uzbekistanFlights
                viewController3.secondFlights = []
                viewController3.numberOfSection = 1
            } else if flightFilter[index] == "International Flights" {
                viewController3.firstFlights = internationalFlights
                viewController3.secondFlights = []
                viewController3.numberOfSection = 1
            }
            viewController3.tableView.reloadData()
        case .hotel:
            if hotelFilterData[index] == "All" {
                viewController1.hotels = hotels
            } else {
                viewController1.hotels = hotels.filter { $0.city == hotelFilterData[index] }
            }
            viewController1.tableView.reloadData()
        case .restaurant:
            if hotelFilterData[index] == "All" {
                viewController2.restaurants = restaurant
            } else {
                viewController2.restaurants = restaurant.filter { $0.city == restaurantFilterData[index] }
            }
            viewController2.tableView.reloadData()
        }
        
    }
}
