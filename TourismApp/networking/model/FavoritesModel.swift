//
//  FavoritesModel.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/09/23.
//

import Foundation

struct UserData: Codable {
    let email: String
    let favorites: [MainDestination]?
}
