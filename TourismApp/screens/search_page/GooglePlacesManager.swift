//
//  GooglePlacesManager1.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 18/09/23.
//

import UIKit
import GooglePlaces
import CoreLocation

struct Place {
    let name: String
    let identifier: String
}

class GooglePlacesManager {
    
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
        case failedToGetCoordinates
    }
    
    
    func findPlaces(query: String, completion: @escaping(Result<[Place], Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UZB"
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
            guard let result = result, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let places: [Place] = result.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })
            
            completion(.success(places))
        }
        
    }
    
    
    func resolveLocation(for place: Place, completion: @escaping(Result<CLLocationCoordinate2D, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coordinate))
        }
    }
}
