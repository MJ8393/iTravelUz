//
//  HotelsVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 03/12/23.
//

import UIKit
import MaterialDesignWidgets

class HotelsVC: UIViewController {
    
//    lazy var segmentedControl: UISegmentedControl = {
//        let items = ["Hotels", "Restaurants"]
//        let segmentedControl = UISegmentedControl(items: items)
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.backgroundColor = .systemBackground
//        segmentedControl.addTarget(self, action: #selector(itemDidChange(_:)), for: .valueChanged)
//        return segmentedControl
//    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 21 / 2
        textField.backgroundColor = .systemGray6
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        textField.leftViewMode = .always
        let placeholderText = " Search"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedText = NSAttributedString(string: "", attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.mainColor
        return textField
    }()
    
    lazy var hotelsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HotelsTableViewCell.self, forCellReuseIdentifier: HotelsTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSegmentedControl()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hotelsTableView.frame = CGRect(x: 0, y: 110, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 130)
        searchTextField.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
//        view.addSubview(segmentedControl)
        view.addSubview(searchTextField)
        view.addSubview(hotelsTableView)
        navigationItem.titleView = searchTextField
        searchTextField.becomeFirstResponder()
    }
    
    func applyConstraints() {
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(100)
//        }
    }
    
    func configureSegmentedControl() {
        let sgLine = MaterialSegmentedControl(selectorStyle: .line, fgColor: UIColor.mainColor, selectedFgColor: UIColor.mainColor, selectorColor: UIColor.mainColor, bgColor: .systemBackground)
        
        setSegments(sgLine, 5.0)
        sgLine.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        self.view.addSubview(sgLine)
        sgLine.translatesAutoresizingMaskIntoConstraints = false
        
        sgLine.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setSegments(_ segmentedControl: MaterialSegmentedControl, _ cornerRadius: CGFloat) {
        // Button background needs to be clear, it will be set to clear in segmented control anyway.
        let button1 = MaterialButton(text: "Hotels", textColor: UIColor.mainColor, bgColor: .clear, cornerRadius: cornerRadius)
        let button2 = MaterialButton(text: "Restaurants", textColor: UIColor.mainColor, bgColor: .clear, cornerRadius: cornerRadius)
        segmentedControl.segments.append(button1)
        segmentedControl.segments.append(button2)
    }
}

extension HotelsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelsTableViewCell.identifier, for: indexPath) as? HotelsTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
