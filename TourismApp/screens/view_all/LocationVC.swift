//
//  LocationVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 12/09/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationVC: mapVC {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.377491, longitude: 64.585262)
    var gallery: [Gallery] = []
    
    override func loadView() {
        setMapView(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
       // marker?.iconView = setMarkerImageView(with: gallery)
    }
}
