//
//  PagerViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 03/12/23.
//

import UIKit


class PagerController: DTPagerController {
    
    let viewController1 = HotelViewController()
    let viewController2 = RestaurantViewController()
    let viewController3 = FlightViewController()
    
    var hotelFilterData = [String]()
    var restaurantFilterData = [String]()
    
    var restaurant = [RestaurantModel]()
    var hotels = [HotelModel]()

    
    init() {
        super.init(viewControllers: [])
        title = "Explore"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: #selector(filterTapped))
        rightBarButtonItem.tintColor = .label
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .mainColor

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

//        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.mainColor], for: .selected)
//        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .disabled)
        textColor = UIColor.black
        pageScrollView.backgroundColor = .clear
        pageSegmentedControl.backgroundColor = .clear
        pageSegmentedControl.tintColor = .clear
        
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        getAllHotels()
        getAllRestaurants()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func filterTapped() {
        let vc = FilterViewController()
        if currentIndeX == 0 {
            vc.cities = hotelFilterData
        } else if currentIndeX == 1 {
            vc.cities = restaurantFilterData
        } else if currentIndeX == 2 {
            vc.cities = flightFilterData
        }
        navigationController?.presentPanModal(vc)
    }
    
    func getAllHotels() {
        hotelFilterData = []
        hotels = []
        API.shared.getAllHotels { [weak self] result in
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
            case .failure(let error):
                print("xx", error)
            }
        }
    }
    
    func getAllRestaurants() {
        restaurantFilterData = []
        restaurant = []
        API.shared.getAllRestaurant { [weak self] result in
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
