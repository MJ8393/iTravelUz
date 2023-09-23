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
}

struct MainLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct MainRecomentationLevel: Codable {
    let level: Int?
}

