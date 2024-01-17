//
//  SearchContentVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 22/09/23.
//

import UIKit
import CoreLocation

protocol SearchContentVCDelegate: AnyObject, mapVC {
    func didTapPlace(model: SearchDestinationModel)
    func textFieldBeginEditing()
}

class SearchContentVC: BaseViewController, UITextFieldDelegate {
    
    weak var delegate: SearchContentVCDelegate?
    var places: [SearchDestinationModel] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "search".translate()
        label.textColor = UIColor.label
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 7, y: 4, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass")
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 45 / 2
        textField.backgroundColor = .systemGray6
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftView.addSubview(searchIconImageView)
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        
        let placeholderText = "search_place".translate()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
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
        textField.addTarget(self, action: #selector(SearchContentVC.textFieldDidChange(_:)), for: .editingChanged)
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
        view.backgroundColor = UIColor(named: "search_color")
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(tableView)
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let seconds = 0.5
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//            self.delegate?.textFieldBeginEditing()
//        }
//
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 20, y: 25, width: view.frame.size.width - 40, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: 25 + 10 + label.frame.size.height, width: view.frame.size.width - 20, height: 45)
        let tableY: CGFloat = textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        title = "search".translate()
        label.text = "search".translate()
        textField.placeholder = "search_place".translate()
        tableView.reloadData()
    }
    
    var isLoading: Bool = false
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            if isLoading {
                self.dissmissLoadingView()
            }
            showLoadingView()
            isLoading = true
            API.shared.searchDestination(name: text) { result in
                if self.isLoading != false {
                    self.dissmissLoadingView()
                    self.isLoading = false
                }
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
        } else {
            DispatchQueue.main.async {
                self.places = []
                self.tableView.reloadData()
            }
        }
    }
}


extension SearchContentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name?.getName()
        cell.textLabel?.textColor = .label
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]
        self.delegate?.marker?.title = place.name?.getName()
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(model: SearchDestinationModel(id: place.id, name: place.name, location: place.location, city_name: place.city_name, gallery: place.gallery, description: place.description, recommendationLevel: place.recommendationLevel, comments: place.comments))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchContentVC {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldBeginEditing()
        return true
    }
}
