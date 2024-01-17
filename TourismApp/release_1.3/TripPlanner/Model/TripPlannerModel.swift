//
//  TripPlannerModel.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 15/01/24.
//

import UIKit

struct PlanTripModel: Codable {
    let destinations: [[MainDestination]]
    let number_of_destinations_per_day: Int
    let number_of_hotels: Int
    let number_of_restaurants: Int
    let restaurants: [RestaurantModel]?
    let hotels: [HotelModel]?
}

struct TripPlannerModel {
    let CityName: String
    let StartDate: String
    let daysLength: Int
    let budget: Int
    let interests: [String]?
}
