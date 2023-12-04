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

        perferredScrollIndicatorHeight = 2.0
        
        viewController1.title = "Hotels"

        viewController2.title = "Restaurants"

        viewControllers = [viewController1, viewController2]
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
    
    @objc func filterTapped() {
            // Code to be executed when the right navigation item is tapped
        }
    
    func getAllHotels() {
        API.shared.getAllHotels { [weak self] result in
            switch result {
            case .success(let hotels):
                self?.viewController1.hotels = hotels
            case .failure(let error):
                print("xx", error)
            }
        }
    }
    
    func getAllRestaurants() {
        API.shared.getAllRestaurant { [weak self] result in
            switch result {
            case .success(let restaurants):
                self?.viewController2.restaurants = restaurants
            case .failure(let error):
                print("xx", error)
            }
        }
    }

}
