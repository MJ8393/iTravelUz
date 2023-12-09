//
//  SearchVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 12/09/23.
//

import UIKit
import GoogleMaps
import FloatingPanel

class SearchVC: mapVC {
    
    let fpc = FloatingPanelController()
    let searchPlaceVC = SearchCotentVC()
    let appearance = SurfaceAppearance()
    
    override func loadView() {
        setMapView()
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFPC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // mapView?.frame = view.bounds
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        title = "search".translate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.fpc.move(to: .full, animated: true)
        }
    }
    
    private func setFPC() {
        fpc.delegate = self
        fpc.set(contentViewController: searchPlaceVC)
        searchPlaceVC.delegate = self
        fpc.view.frame = view.bounds
        fpc.contentMode = .fitToBounds
        fpc.layout = SearchFloatingPanelLayout()
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
    
        // Define shadows
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
        fpc.track(scrollView: searchPlaceVC.tableView)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}

class SearchFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 110.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

extension SearchVC: SearchContentVCDelegate {
    func didTapPlace(model: SearchDestinationModel) {
        let vc = InfoVC()
        if let location = model.location {
            vc.destination = MainDestination(id: model.id, name: model.name, location: location, city_name: model.city_name, description: model.description, recommendationLevel: model.recommendationLevel, gallery: model.gallery, comments: model.comments, tts: nil)
        }
//        vc.coordinate = coordinate
//        vc.cityLabelText = text
//        vc.cityName = name
//        vc.gallery = gallery
        navigationController?.pushViewController(vc, animated: false)
        searchPlaceVC.textField.text = ""
    }
    
    func textFieldBeginEditing() {
        UIView.animate(withDuration: 0.3) {
            self.fpc.move(to: .full, animated: true)
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

extension SearchVC: FloatingPanelControllerDelegate {
    func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
        if fpc.state == .full {
            self.searchPlaceVC.textField.becomeFirstResponder()
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

