//
//  SearchVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 12/09/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FloatingPanel

class SearchVC: mapVC {
    
    let mainfpc = FloatingPanelController()
    let panel = FloatingPanelController()
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        let vc = ViewController()
        vc.delegate = self
        mainfpc.set(contentViewController: vc)
        mainfpc.addPanel(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView?.frame = view.bounds
    }
}

extension SearchVC: ViewControllerDelegate {
    
    func didTapPlace(with coordinate: CLLocationCoordinate2D, text: String?, name: String?, images: [GalleryModel]) {
        mainfpc.dismiss(animated: true)
        self.coordinate = coordinate
        setMapView(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17)
        marker?.iconView = setMarkerImageView(with: "marker_icon")
        marker?.position = coordinate
        let vc = InfoWindowVC()
        vc.delegate = self
        vc.cityLabelText = text
        vc.cityName = name
        vc.images = images
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
    }
}


extension SearchVC: InfoWindowVCDelegate {
    func didTapGoButton() {
        let googleMapsURLString = "comgooglemaps://?q=\(String(describing: coordinate!.latitude)),\(String(describing: coordinate!.longitude))"
        
        if let googleMapsURL = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            let googleMapsWebURLString = "https://maps.google.com/?q=\(coordinate!.latitude),\(coordinate!.longitude)"
            if let googleMapsWebURL = URL(string: googleMapsWebURLString) {
                UIApplication.shared.open(googleMapsWebURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func didTapShareButton(_ sender: UIButton) {
        guard let url = URL(string: "https://maps.google.com/maps?q=\(String(describing: coordinate!.latitude)),\(String(describing: coordinate!.longitude))") else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareSheetVC, animated: true)
        shareSheetVC.popoverPresentationController?.sourceView = sender
        shareSheetVC.popoverPresentationController?.sourceRect = view.frame
    }
    
    
    func didTapXButton() {
        panel.dismiss(animated: true)
        let vc = ViewController()
        vc.delegate = self
        mainfpc.set(contentViewController: vc)
        mainfpc.addPanel(toParent: self)
        mapView?.clear()
    }
}

