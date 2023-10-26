//
//  GooglePlacesManager1.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 18/09/23.
//

import UIKit
import GooglePlaces
import CoreLocation

class GooglePlacesManager {
    
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    func resolveLocation(for place: SearchDestinationModel, completion: @escaping(Result<CLLocationCoordinate2D, Error>) -> Void) {
        let coordinate = CLLocationCoordinate2D(latitude: place.location?.latitude ?? 41.2995, longitude: place.location?.longitude ?? 69.2401)
        completion(.success(coordinate))
    }
}
