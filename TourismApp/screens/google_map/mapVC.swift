//
//  mapVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 10/09/23.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class mapVC: UIViewController {

    let manager = CLLocationManager()
    var mapView: GMSMapView?
    var marker: GMSMarker?
    var markerImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        navigationController?.navigationBar.tintColor = .black
    }

    
    func setMapView(latitude: Double = 41.377491, longitude: Double = 64.585262, zoom: Float = 5.0) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        marker = GMSMarker()
        marker?.map = mapView
        mapView?.selectedMarker = marker
        view.addSubview(mapView!)
    }
    
    
    func setMarkerImageView(with gallery: [GalleryModel]) -> UIImageView {
        let markerImageView = ActivityImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        markerImageView.layer.cornerRadius = markerImageView.frame.size.width / 2
        markerImageView.layer.masksToBounds = true
        markerImageView.layer.borderWidth = 3
        markerImageView.layer.borderColor = UIColor.white.cgColor
        if !gallery.isEmpty {
            markerImageView.loadImage(url: gallery[0].url)
        } else {
            markerImageView.stopLoading()
            markerImageView.image = nil
        }
        markerImageView.contentMode = .scaleAspectFill
        return markerImageView
    }
    
}
