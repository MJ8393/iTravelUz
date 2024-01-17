//
//  TripLengthTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 06/01/24.
//

import UIKit

class TripLengthTableViewCell: UITableViewCell {

    var daysCount: Int = 1
    static var tripLength: Int = 1
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
    
    lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar.badge.clock", withConfiguration: largeConfig))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var tripLengthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Total days:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill", withConfiguration: largeConfig), for: .normal)
        button.tintColor = .secondaryLabel
        button.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    @objc func plusButtonPressed() {
        guard daysCount < 7 else { return }
        Vibration.light.vibrate()
        daysCount += 1
        updateDaysLabel(days: daysCount)
        
        guard daysCount < 7 else {
            plusButton.tintColor = .secondaryLabel
            return
        }
        plusButton.tintColor = .label
        
        guard daysCount > 1 else {
            minusButton.tintColor = .secondaryLabel
            return
        }
        minusButton.tintColor = .label
    }
    
    @objc func minusButtonPressed() {
        guard daysCount > 1 else { return }
        Vibration.light.vibrate()
        daysCount -= 1
        plusButton.tintColor = .label
        updateDaysLabel(days: daysCount)
        
        guard daysCount > 1 else {
            minusButton.tintColor = .secondaryLabel
            return
        }
        minusButton.tintColor = .label
        
        guard daysCount < 7 else {
            plusButton.tintColor = .secondaryLabel
            return
        }
        plusButton.tintColor = .label
    }
    
    func updateDaysLabel(days: Int) {
        let count = days
        guard count >= 1, count <= 7 else { return }
        let text = "\(count)"
        daysLabel.text = text
        TripLengthTableViewCell.tripLength = count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        subView.addSubview(tripLengthLabel)
        tripLengthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView)
            make.leading.equalTo(calendarImageView.snp.trailing).offset(10)
        }
        
        subView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(tripLengthLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        
        subView.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tripLengthLabel)
            make.trailing.equalTo(plusButton.snp.leading).offset(-10)
        }
        
        subView.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(tripLengthLabel)
            make.trailing.equalTo(daysLabel.snp.leading).offset(-10)
            make.width.height.equalTo(30)
        }
    }
}
