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
    let name: DestionationName?
    let location: MainLocation?
    let city_name: CityName?
    let description: DescriptionString?
    let recommendationLevel: MainRecomentationLevel?
    let gallery: [Gallery]?
    let comments: [MainComment]?
}

struct MainLocation: Codable {
    let latitude: Double?
    let longitude: Double?
}

struct MainRecomentationLevel: Codable {
    let level: Int?
}

struct Gallery: Codable {
    let url: String
}

struct MainComment: Codable {
    let user: String?
    let text: String?
    let language: String?
}

// Cities
struct CityModel: Codable {
    let cities: [City]?
}

struct City: Codable {
    let id: String
    let name: DestionationName?
    let location: MainLocation
    let country: CityName?
    let gallery: [Gallery]?
    let description: DescriptionString?
    let recommendationLevel: MainRecomentationLevel?
    let comments: [MainComment]?
}

struct CountryName: Codable {
    let english: String?
    let arabic: String?
}

// POPULAR
struct PopularModel: Codable {
    let destinations: [MainDestination]
}

