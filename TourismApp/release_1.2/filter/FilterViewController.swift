//
//  FilterViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/12/23.
//

import UIKit
import PanModal


protocol FilterViewControllerDelegate: AnyObject {
    func indexTapped(_ index: Int, _ type: FilterType)
}

struct CityFilter {
    let name: String
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    var contentHeight = 250.0
    var cities = [String]()
    
    var filterType: FilterType = .hotel
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "filter".translate()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: String.init(describing: FilterTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        //tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        if UD.filterHotel == nil {
            UD.filterHotel = "All"
        }
        
        if UD.filterFlights == nil {
            UD.filterFlights = "All"
        }
        
        if UD.filterRestaurant == nil {
            UD.filterRestaurant = "All"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentHeight()
    }
    
    func initViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(sortLabel)
        sortLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(25)
        }
        
        subView.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(sortLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setContentHeight() {
        self.contentHeight = tableView.contentSize.height + 60.0
        self.panModalSetNeedsLayoutUpdate()
        self.panModalTransition(to: .shortForm)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: FilterTableViewCell.self), for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        
        cell.setData(cities[indexPath.row])
//        if indexPath.row == getChoosedIndex() {
//            cell.chooseImageView.isHidden = false
//        } else {
//            cell.chooseImageView.isHidden = true
//        }
        switch filterType {
        case .flight:
            if UD.filterFlights == cities[indexPath.row] {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        case .hotel:
            print("xxxx", UD.filterHotel, UD.filterRestaurant, UD.filterFlights)
            if UD.filterHotel == cities[indexPath.row] {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        case .restaurant:
            if UD.filterRestaurant == cities[indexPath.row] {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func getChoosedIndex() -> Int {
        var index = 0
        return index
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.indexTapped(indexPath.row, filterType)
        switch filterType {
        case .flight:
            UD.filterFlights = cities[indexPath.row]
        case .hotel:
            UD.filterHotel = cities[indexPath.row]
        case .restaurant:
            UD.filterRestaurant = cities[indexPath.row]
        }
        dismiss(animated: true)
    }
}

extension FilterViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return tableView
    }

    var longFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var shortFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}

enum FilterType {
    case hotel
    case restaurant
    case flight
}
