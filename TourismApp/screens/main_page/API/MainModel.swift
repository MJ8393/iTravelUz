//
//  MainModel.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 21/09/23.
//

import Foundation

struct MainDestionationModel: Codable {
    let destinations: [MainDestination]
}

struct MainDestination: Codable {
    let id: String
    let name: String
    let location: MainLocation
    let city_name: String?
    let description: String?
    let recommendationLevel: MainRecomentationLevel?
    let gallery: [Gallery]?
}

struct MainLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct MainRecomentationLevel: Codable {
    let level: Int?
}

struct Gallery: Codable {
    let url: String
}

// Cities
struct CityModel: Codable {
    let cities: [City]?
}

struct City: Codable {
    let id: String
    let name: String
    let country: String
    let gallery: [Gallery]?
}

// POPULAR
struct PopularModel: Codable {
    let our_results: [MainDestination]
}
