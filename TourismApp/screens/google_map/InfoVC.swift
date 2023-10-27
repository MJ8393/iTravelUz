//
//  InfoVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 25/10/23.
//

import UIKit
import CoreLocation
import FloatingPanel

class InfoVC: mapVC {
    
    let fpc = FloatingPanelController()
    let contentVC = InfoContentVC()
    let appearance = SurfaceAppearance()
    
//    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.377491, longitude: 64.585262)
    var destination: MainDestination?
    var isLiked: Bool = false
    
    var isCity: Bool = false
    var city: City?
    
    
    override func loadView() {
        if isCity {
            if let city = city {
                if let location = city.location {
                    setMapView(latitude: location.latitude ?? Helper.getDefaultLocation().lat, longitude: location.longitude ?? Helper.getDefaultLocation().lon, zoom: 6.3)
                }
            }
        } else {
            if let destination = destination {
                if let location = destination.location {
                    setMapView(latitude: location.latitude ?? Helper.getDefaultLocation().lat, longitude: location.longitude ?? Helper.getDefaultLocation().lon, zoom: 6.3)
                }
            }
        }
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setFPC()
        view.addSubview(fpc.view)
        addChild(fpc)
        setContentVC()
        setMarker()
        
        let backButton = CustomBarButtonView(image: UIImage(systemName: "chevron.backward")!)
        backButton.buttonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setMarker() {
        if isCity {
            if let city = city, let gallery = city.gallery {
                if let location = city.location {
                    setMarker(location: location)
                }
                marker?.iconView = setMarkerImageViewString(with: gallery)
            }
        } else {
            if let destination = destination, let gallery = destination.gallery {
                if let location = destination.location {
                    setMarker(location: location)
                }
                marker?.iconView = setMarkerImageView(with: gallery)
            }
        }
    }
    
    private func setContentVC() {
        if isCity {
            if let city = city {
                contentVC.isCity = true
                contentVC.cityLabel.text = city.name?.getName()
                contentVC.descriptionLabel.text = city.country?.getCountry()
                if let gallery = city.gallery {
                    contentVC.cityGallery = gallery
                    contentVC.likeButton.isHidden = true
                }
            }

        } else {
            contentVC.cityLabel.text = destination?.name?.getName()
            contentVC.descriptionLabel.text = destination?.city_name?.getCityName()
            if let gallery = destination?.gallery {
                contentVC.gallery = gallery
            }
            contentVC.likeButton.isHidden = false
            if let favorites = UD.favorites, let destionation = destination {
                if favorites.contains(destionation.id) {
                    isLiked = true
                    contentVC.likeButton.setImage(UIImage(systemName: "heart.fill"))
                } else {
                    isLiked = false
                    contentVC.likeButton.setImage(UIImage(systemName: "heart")!)
                }
            }
        }
    }
    
    
    private func setFPC() {
        fpc.delegate = self
        fpc.view.frame = view.bounds
        fpc.contentMode = .fitToBounds
        fpc.layout = InfoFloatingPanelLayout()
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self, animated: true)
        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fpc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        fpc.show(animated: true) {
            self.fpc.didMove(toParent: self)
        }
        
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 25
        shadow.spread = 8
        appearance.shadows = [shadow]
        fpc.surfaceView.grabberHandle.backgroundColor = UIColor.chatGrayColor
        // Define corner radius and background color
        appearance.cornerRadius = 22
        appearance.backgroundColor = .clear
        // Set the new appearance
        fpc.surfaceView.appearance = appearance
    }
}

class InfoFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.62, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 110.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

extension InfoVC: FPContentVCDelegate {
    func didTapGoButton() {
        if isCity {
            let googleMapsURLString = "comgooglemaps://?q=\(String(describing: city?.location?.latitude)),\(String(describing: city?.location?.longitude))"
            
            if let googleMapsURL = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(googleMapsURL) {
                UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
            } else {
                let googleMapsWebURLString = "https://maps.google.com/?q=\(String(describing: city?.location?.latitude)),\(String(describing: city?.location?.longitude))"
                if let googleMapsWebURL = URL(string: googleMapsWebURLString) {
                    UIApplication.shared.open(googleMapsWebURL, options: [:], completionHandler: nil)
                }
            }
        } else {
            let googleMapsURLString = "comgooglemaps://?q=\(String(describing: destination?.location?.latitude)),\(String(describing: destination?.location?.longitude))"
            
            if let googleMapsURL = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(googleMapsURL) {
                UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
            } else {
                let googleMapsWebURLString = "https://maps.google.com/?q=\(String(describing: destination?.location?.latitude)),\(String(describing: destination?.location?.longitude))"
                if let googleMapsWebURL = URL(string: googleMapsWebURLString) {
                    UIApplication.shared.open(googleMapsWebURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func didTapShareButton(_ sender: UIButton) {
        if isCity {
            if let latitude = city?.location?.latitude, let longitude = city?.location?.longitude {
                guard let url = URL(string: "https://maps.google.com/maps?q=\(latitude)),\(longitude))") else { return }
                let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                present(shareSheetVC, animated: true)
                shareSheetVC.popoverPresentationController?.sourceView = sender
                shareSheetVC.popoverPresentationController?.sourceRect = view.frame
            }
        } else {
            if let latitude = destination?.location?.latitude, let longitude = destination?.location?.longitude {
                guard let url = URL(string: "https://maps.google.com/maps?q=\(latitude)),\(longitude))") else { return }
                let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                present(shareSheetVC, animated: true)
                shareSheetVC.popoverPresentationController?.sourceView = sender
                shareSheetVC.popoverPresentationController?.sourceRect = view.frame
            }
        }
    }
    
    func didTapLikeButton() {
        if isLiked {
            contentVC.likeButton.setImage(UIImage(systemName: "heart"))
            if let id = destination?.id {
                API.shared.removeFromFavorites(destionationID: id) { result in
                    switch result {
                    case .success(_):
                        self.showAlert(title: "success".translate(), message: "\(self.destination?.name?.getName() ?? "") " + "success_message_2".translate())
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showAlert(title: "fail".translate(), message: "\(self.destination?.name?.getName() ?? "") " + "fail_message_2".translate())
                        self.contentVC.likeButton.setImage(UIImage(systemName: "heart.fill")!)
                    }
                }
            }
        } else {
            Vibration.light.vibrate()
            contentVC.likeButton.setImage(UIImage(systemName: "heart.fill")!)
            if let id = self.destination?.id {
                API.shared.addToFavorites(destionationID: id) { result in
                    switch result {
                    case .success(_):
                        self.showAlert(title: "success".translate(), message: "\(self.destination?.name?.getName() ?? "") " + "success_message_1".translate())
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showAlert(title: "fail".translate(), message: "\(self.destination?.name?.getName() ?? "") " + "fail_message_1".translate())
                        self.contentVC.likeButton.setImage(UIImage(systemName: "heart")!)
                    }
                }
            }
        }
        self.isLiked = !self.isLiked
    }
    
    func didTapXButton() {
        fpc.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
        mapView?.clear()
    }
}

extension InfoVC: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        if vc.isAttracting == false {
            let loc = vc.surfaceLocation
            let minY = vc.surfaceLocation(for: .full).y - 15.0
            let maxY = vc.surfaceLocation(for: .tip).y + 15.0
            vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
    
    func shouldProjectMomentum(_ fpc: FloatingPanelController, to proposedState: FloatingPanelPosition) -> Bool {
        return true
    }
    
    func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
        return true
    }
}
