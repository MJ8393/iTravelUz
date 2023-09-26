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
    func textFieldBeginEditing()
}

class ViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: ViewControllerDelegate?
    private var places: [SearchDestinationModel] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 45 / 2
        textField.backgroundColor = .chatGrayColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        let placeholderText = "Search for a place"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeHolderColor,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let attributedText = NSAttributedString(string: "", attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.mainColor
        textField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        label.frame = CGRect(x: 20, y: 25, width: label.frame.size.width, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: 25 + 10 + label.frame.size.height, width: view.frame.size.width - 20, height: 45)
        let tableY: CGFloat = textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
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
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
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

extension ViewController {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldBeginEditing()
        return true
    }
}
