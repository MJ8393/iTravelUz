//
//  ViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 22/09/23.
//

import UIKit
import CoreLocation

protocol ViewControllerDelegate: AnyObject, mapVC {
    func didTapPlace(with coordinate: CLLocationCoordinate2D, text: String?, name: String?, images: [GalleryModel])
}

class ViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: ViewControllerDelegate?
    private var places: [SearchDestinationModel] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search for a place"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        return field
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(tableView)
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: 20+label.frame.size.height, width: view.frame.size.width - 20, height: 50)
        let tableY: CGFloat = textField.frame.origin.y+textField.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height-tableY)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            API.shared.searchDestination(name: text) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.places = data.destinations
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]
        self.delegate?.marker?.title = place.name
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate, text: place.name, name: place.city_name, images: place.gallery ?? [])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
