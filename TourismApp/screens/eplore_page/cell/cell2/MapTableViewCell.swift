//
//  MapTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/10/23.
//

import UIKit
import GoogleMaps

class MapTableViewCell: UITableViewCell {
    
    var mapView = GMSMapView()

    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(mapView)
        mapView.layer.cornerRadius = 22
        mapView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
    }
    
    func showMarker(position: CLLocationCoordinate2D, title: String, Snippet: String){
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = Snippet
        marker.map = mapView
    }
   
    func setMap(latitude: Double, longitude: Double, title: String, Snippet: String) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target, title: title, Snippet: Snippet)
    }
}
