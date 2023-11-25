//
//  TopView.swift
//  Translator
//
//  Created by Mekhriddin Jumaev on 31/10/23.
//

import UIKit

protocol TopViewDelegate: AnyObject {
    func fromLabelTapped()
    func toLabelTapped()
    func exchangeTapped()
}

class TopView: UIView {
    
    weak var delegate: TopViewDelegate?
    
    var languages = [String: String]()

    lazy var subView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
//        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor(named: "TranslateColor")
        return view
    }()
    
    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        let gesureRecog = UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesureRecog)
        return label
    }()
    
    lazy var toLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        let gesureRecog = UITapGestureRecognizer(target: self, action: #selector(toLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesureRecog)
        return label
    }()
    
    lazy var centerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        let gesureRecog = UITapGestureRecognizer(target: self, action: #selector(exchangeTapped))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "arrow.left.arrow.right")!.withAlignmentRectInsets(UIEdgeInsets(top: -13, left: -13, bottom: -13, right: -13))
        imageView.addGestureRecognizer(gesureRecog)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(subView)
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        subView.addSubview(centerImage)
//        centerImage.backgroundColor = .red
        centerImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
            
        }
        
        subView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalTo(centerImage.snp.left).offset(0)
            make.top.bottom.equalToSuperview()
        }
        
        subView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.left.equalTo(centerImage.snp.right).offset(0)
            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc func fromLabelTapped() {
        delegate?.fromLabelTapped()
    }
    
    @objc func toLabelTapped() {
        delegate?.toLabelTapped()
    }
    
    @objc func exchangeTapped() {
        delegate?.exchangeTapped()
    }
}
