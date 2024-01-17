//
//  AITripPlannerViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/01/24.
//

import UIKit

class SearchPlaceViewController: UIViewController {

    var searchResults = [City]()
    var isSuccessfullyLoaded: Bool = false
    static var city: City?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Where do you want to go?"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 10, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "magnifyingglass")
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
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
        textField.addTarget(self, action: #selector(editingDidChange(_:)), for: .allEditingEvents)
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(SuggestedTableViewCell.self, forCellReuseIdentifier: String(describing: SuggestedTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @objc func editingDidChange(_ textField: UITextField) {
        if let query = textField.text, !query.isEmpty {
            showLoadingView()
            API.shared.searchCity(name: query) { [weak self] result in
                self?.dissmissLoadingView()
                switch result {
                case .success(let data):
                    self?.searchResults = data.cities
                    self?.isSuccessfullyLoaded = true
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.dissmissLoadingView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            dissmissLoadingView()
        }
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(50)
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SuggestedTableViewCell.self), for: indexPath) as? SuggestedTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.setData(model: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vibration.light.vibrate()
        textField.text = searchResults[indexPath.row].name?.getName()
        SearchPlaceViewController.city = searchResults[indexPath.row]
        NotificationCenter.default.post(name: .didSelectCell, object: nil, userInfo: ["didChoosePlace": true])
    }
}
