//
//  MapTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/12/23.
//

import UIKit
import GoogleMaps

protocol GoogleMapTableViewCellDelegate2: AnyObject {
    func mapViewTapped()
}

class GoogleMapTableViewCell: UITableViewCell {
    
    var mapView = GMSMapView()
    
    weak var delegate: GoogleMapTableViewCellDelegate2?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "phone.fill")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var phoneNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "+998991234567"
        return label
    }()
    
    lazy var networkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "network")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var networkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.text = "www.google.com"
        return label
    }()
    
    
    lazy var contactsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.text = "contacts".translate()
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func mapTapped() {
        delegate?.mapViewTapped()
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(contactsLabel)
        contactsLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        subView.addSubview(phoneNumLabel)
        phoneNumLabel.snp_makeConstraints { make in
            make.top.equalTo(contactsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(37)
        }
        
        subView.addSubview(phoneImageView)
        phoneImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.centerY.equalTo(phoneNumLabel)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(networkLabel)
        networkLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(networkImageView)
        networkImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.centerY.equalTo(networkLabel)
            make.height.width.equalTo(18)
        }
        
        subView.addSubview(mapView)
        mapView.layer.cornerRadius = 22
        mapView.isUserInteractionEnabled = true
        mapView.snp.makeConstraints { make in
            make.top.equalTo(networkImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
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
    
    func setContactData(phoneNumber: String, website: String) {
        phoneNumLabel.text = phoneNumber
        if website == "" {
            networkLabel.isHidden = true
            networkImageView.isHidden = true
            mapView.snp.updateConstraints { make in
                make.top.equalTo(networkImageView.snp.bottom).offset(-8)
            }
        } else {
            mapView.snp.updateConstraints { make in
                make.top.equalTo(networkImageView.snp.bottom).offset(20)
            }
            networkLabel.text = website
        }
    }
   
    func setMap(latitude: Double, longitude: Double, title: String, Snippet: String) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target, title: title, Snippet: Snippet)
    }
}
