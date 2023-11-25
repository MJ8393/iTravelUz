//
//  CountriesListViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/11/23.
//

import UIKit

protocol CountriesListDelegate: AnyObject {
    func didSelectCountry(key: String)
}

class CountriesListViewController: UIViewController {
    
    var languages = [String: String]()
        
    var isTo: Bool = true
    
    var languageArray = [String]()
    
    weak var delegate: CountriesListDelegate?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: String.init(describing: CountryTableViewCell.self))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var currentLanguage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Languages"
        languageArray = Array(languages.values)
        languageArray = languageArray.sorted()
        
        if isTo {
            currentLanguage = UD.to ?? "uz"
        } else {
            currentLanguage = UD.from ?? "uz"
        }
        
        initViews()
    }
    
    private func initViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: CountryTableViewCell.self), for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
        cell.countryLabel.text = languageArray[indexPath.row]
        if let languageString = languages[currentLanguage] {
            if cell.countryLabel.text == languageString {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var foundKey = "uz"
        for (key, value) in languages {
            if value == languageArray[indexPath.row] {
                foundKey = key
                break
            }
        }
        if isTo {
            UD.to = foundKey
        } else {
            UD.from = foundKey
        }
        delegate?.didSelectCountry(key: foundKey)
        self.dismiss(animated: true)
    }
}
