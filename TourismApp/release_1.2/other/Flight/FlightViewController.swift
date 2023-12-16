//
//  FlightViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 16/12/23.
//

import UIKit

class FlightViewController: UIViewController {
    
    var numberOfSection = 2
    
    var firstFlights = [Flight]()
    var secondFlights = [Flight]()

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FloightTableViewCell.self, forCellReuseIdentifier: String.init(describing: FloightTableViewCell.self))
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        firstFlights = uzbekistanFlights
        secondFlights = internationalFlights
    }

    private func initViews() {
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

extension FlightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstFlights.count
        }
        return secondFlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: FloightTableViewCell.self), for: indexPath) as? FloightTableViewCell else { return UITableViewCell() }
//        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.setData(flight: firstFlights[indexPath.row])
        } else {
            cell.setData(flight: secondFlights[indexPath.row])
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = "Flights inside Uzbekistan"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let url = URL(string: firstFlights[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        } else {
            guard let url = URL(string: secondFlights[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


let uzbekistanFlights = [
    Flight(fromCity: "Buxoro", toCity: "Toshkent", price: "dan 192 010 UZS", link: "https://www.aviasales.uz/routes/bhk/tas"),
    Flight(fromCity: "Fargʻona", toCity: "Toshkent", price: "dan 118 392 UZS", link: "https://www.aviasales.uz/routes/feg/tas"),
    Flight(fromCity: "Qarshi", toCity: "Toshkent", price: "dan 164 128 UZS", link: "https://www.aviasales.uz/routes/ksq/tas"),
    Flight(fromCity: "Nukus", toCity: "Toshkent", price: "dan 392 947 UZS", link: "https://www.aviasales.uz/routes/ncu/tas"),
    Flight(fromCity: "Namangan", toCity: "Toshkent", price: "dan 108 228 UZS", link: "https://www.aviasales.uz/routes/nma/tas"),
    Flight(fromCity: "Samarqand", toCity: "Toshkent", price: "dan 100 262 UZS", link: "https://www.aviasales.uz/routes/skd/tas"),
    Flight(fromCity: "Toshkent", toCity: "Buxoro", price: "dan 210 139 UZS", link: "https://www.aviasales.uz/routes/tas/bhk"),
    Flight(fromCity: "Toshkent", toCity: "Fargʻona", price: "dan 145 861 UZS", link: "https://www.aviasales.uz/routes/tas/feg"),
    Flight(fromCity: "Toshkent", toCity: "Qarshi", price: "dan 211 650UZS", link: "https://www.aviasales.uz/routes/tas/ksq"),
    Flight(fromCity: "Toshkent", toCity: "Nukus", price: "dan 428 108 UZS", link: "https://www.aviasales.uz/routes/tas/ncu"),
]

let internationalFlights = [
    Flight(fromCity: "Moskva", toCity: "Buxoro", price: "1 387 472 UZS", link: "https://www.aviasales.uz/routes/mow/bhk"),
    Flight(fromCity: "Moskva", toCity: "Samarqand", price: "dan 1 150 550 UZS", link: "https://www.aviasales.uz/routes/bhk/tas"),
    Flight(fromCity: "Sankt-Peterburg", toCity: "Toshkent", price: "dan 912 941 UZS", link: "https://www.aviasales.uz/routes/led/tas"),
    Flight(fromCity: "Moskva", toCity: "Toshkent", price: "dan 789 329 UZS", link: "https://www.aviasales.uz/routes/mow/tas"),
    Flight(fromCity: "Toshkent", toCity: "Moskva", price: "dan 1 064 434 UZS", link: "https://www.aviasales.uz/routes/tas/mow"),
    Flight(fromCity: "Moskva", toCity: "Samarqand", price: "dan 950 436 UZS", link: "https://www.aviasales.uz/routes/mow/skd"),
    Flight(fromCity: "Istanbul", toCity: "Toshkent", price: "dan 1 672 054 UZS", link: "https://www.aviasales.uz/routes/ist/tas"),
    Flight(fromCity: "Toshkent", toCity: "Istanbul", price: "dan 1 886 039 UZS", link: "https://www.aviasales.uz/routes/tas/ist"),
    Flight(fromCity: "Moskva", toCity: "Namangan", price: "dan 2 879 328 UZS", link: "https://www.aviasales.uz/routes/mow/nma"),
    Flight(fromCity: "Moskva", toCity: "Urganch", price: "dan 1 123 492 UZS", link: "https://www.aviasales.uz/routes/mow/ugc"),
    Flight(fromCity: "Sankt-Peterburg", toCity: "Samarqand", price: "dan 1 666 148 UZS", link: "https://www.aviasales.uz/routes/led/skd"),
    Flight(fromCity: "Sochi", toCity: "Toshkent", price: "dan 1 657 770 UZS", link: "https://www.aviasales.uz/routes/aer/tas"),
    Flight(fromCity: "Buxoro", toCity: "Moskva", price: "dan 1 232 408 UZS", link: "https://www.aviasales.uz/routes/bhk/mow"),
    Flight(fromCity: "Moskva", toCity: "Fargʻona", price: "1 202 055 UZS", link: "https://www.aviasales.uz/routes/mow/feg"),
    Flight(fromCity: "Toshkent", toCity: "Sankt-Peterburg", price: "1 681 943 UZS", link: "https://www.aviasales.uz/routes/tas/led"),
]

struct Flight {
    let fromCity: String
    let toCity: String
    let price: String
    let link: String
}
