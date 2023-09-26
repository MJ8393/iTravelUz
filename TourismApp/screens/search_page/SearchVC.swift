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
    let vc = ViewController()
    let appearance = SurfaceAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        vc.delegate = self
        mainfpc.set(contentViewController: vc)
        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 25
        shadow.spread = 8
        appearance.shadows = [shadow]
        mainfpc.surfaceView.grabberHandle.backgroundColor = UIColor.chatGrayColor
        // Define corner radius and background color
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear
        // Set the new appearance
        mainfpc.surfaceView.appearance = appearance
        mainfpc.delegate = self
        mainfpc.addPanel(toParent: self)
        mainfpc.track(scrollView: vc.tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.mainfpc.move(to: .half, animated: true)
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}

extension SearchVC: ViewControllerDelegate {
    
    func didTapPlace(with coordinate: CLLocationCoordinate2D, text: String?, name: String?, images: [GalleryModel]) {
        mainfpc.dismiss(animated: true)
        self.coordinate = coordinate
        setMapView(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17)
        marker?.iconView = setMarkerImageView(with: images)
        marker?.position = coordinate
        let vc = InfoWindowVC()
        vc.delegate = self
        vc.cityLabelText = text
        vc.cityName = name
        vc.images = images
        self.panel.surfaceView.appearance = self.appearance
        self.panel.set(contentViewController: vc)
        self.panel.addPanel(toParent: self)
        self.panel.delegate = self
        self.panel.track(scrollView: vc.collectionView)
    }
    
    func textFieldBeginEditing() {
        UIView.animate(withDuration: 0.3) {
            self.mainfpc.move(to: .full, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.gestureRecognizers?.removeAll()
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

extension SearchVC: FloatingPanelControllerDelegate {
    func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
        if fpc.state == .full {
            self.vc.textField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }
    
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
