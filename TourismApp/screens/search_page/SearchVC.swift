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
    
    let searchController = UISearchController(searchResultsController: ResultVC())
    var numberOfPlaces: Int = 0
    let panel = FloatingPanelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        searchController.searchBar.backgroundColor = .secondarySystemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a place"
        
        setMapView()
        
        panel.set(contentViewController: InfoWindowVC())
        panel.addPanel(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView?.frame = view.bounds
    }
}

extension SearchVC: UISearchResultsUpdating, ResultVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultVC = searchController.searchResultsController as? ResultVC  else { return }
        resultVC.delegate = self
        
        API.shared.searchDestination(name: query) { result in
            switch result {
            case .success(let data):
                self.numberOfPlaces = data.destinations.count
                DispatchQueue.main.async {
                    resultVC.updateData(destinations: data.destinations)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        searchController.searchBar.resignFirstResponder()
        searchController.dismiss(animated: true)
        setMapView(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.5)
        marker?.iconView = setMarkerImageView(with: "marker_icon")
        marker?.position = coordinate
    }
}

