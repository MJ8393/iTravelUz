//
//  StartDateTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class StartDateTableViewCell: UITableViewCell {

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
    
    lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar", withConfiguration: largeConfig))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Start date:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .systemBackground
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        datePicker.tintColor = .mainColor
        datePicker.addTarget(self, action: #selector(updatedValue), for: .valueChanged)
        return datePicker
    }()
    
    lazy var chooseDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("06, Jan", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updatedValue() {
        
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView)
            make.leading.equalTo(calendarImageView.snp.trailing).offset(10)
        }
        
        subView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(startDateLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
    }
}
