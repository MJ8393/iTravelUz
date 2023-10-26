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
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.377491, longitude: 64.585262)
    var cityLabelText: String?
    var cityName: String?
    var gallery: [Gallery] = []
    
    override func loadView() {
        setMapView(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.3)
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
    }
    
    private func setMarker() {
        setMarker(coordinate: coordinate)
        marker?.iconView = setMarkerImageView(with: gallery)
    }
    
    private func setContentVC() {
        contentVC.cityLabel.text = cityLabelText
        contentVC.descriptionLabel.text = cityName
        contentVC.gallery = gallery
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
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 80.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

extension InfoVC: FPContentVCDelegate {
    func didTapGoButton() {
        let googleMapsURLString = "comgooglemaps://?q=\(String(describing: coordinate.latitude)),\(String(describing: coordinate.longitude))"
        
        if let googleMapsURL = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            let googleMapsWebURLString = "https://maps.google.com/?q=\(coordinate.latitude),\(coordinate.longitude)"
            if let googleMapsWebURL = URL(string: googleMapsWebURLString) {
                UIApplication.shared.open(googleMapsWebURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func didTapShareButton(_ sender: UIButton) {
        guard let url = URL(string: "https://maps.google.com/maps?q=\(String(describing: coordinate.latitude)),\(String(describing: coordinate.longitude))") else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareSheetVC, animated: true)
        shareSheetVC.popoverPresentationController?.sourceView = sender
        shareSheetVC.popoverPresentationController?.sourceRect = view.frame
    }
    
    func didTapLikeButton() {
        
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
