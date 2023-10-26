//
//  mapVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 10/09/23.
//

import UIKit
import GoogleMaps

class mapVC: BaseViewController {
    
    let manager = CLLocationManager()
    var mapView: GMSMapView?
    var marker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()
        //manager.startUpdatingLocation()
    }
    
    override func languageDidChange() {
        super.languageDidChange()
    }
    
    func setMapView(latitude: Double = 41.377491, longitude: Double = 64.585262, zoom: Float = 5.0) {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
    }
    
    func setMarker(location: MainLocation) {
        marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        marker?.map = mapView
    }
    
    func setMarkerImageView(with gallery: [Gallery]) -> UIImageView {
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
