//
//  CommentsViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/10/23.
//

import UIKit
import SwiftyStarRatingView
import PanModal

class CommentsViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var destionation: MainDestination?

    lazy var imageView: ActivityImageView = {
        let imageView = ActivityImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Registan Square"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Samarqand, Uzbekistan"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your score?"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.label
        return label
    }()
    
    let starRatingView = SwiftyStarRatingView()
    
    lazy var yourComments: UILabel = {
        let label = UILabel()
        label.text = "What is your comment?"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor.label
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.label.cgColor
        textView.layer.borderWidth = 1
        textView.tintColor = UIColor.mainColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        initViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        if let destionation = destionation {
            nameLabel.text = destionation.name?.getName()
            placeLabel.text = (destionation.city_name?.getCityName() ?? "Tashkent") + "country_name".translate()
            if let gallery = destionation.gallery {
                if gallery.count != 0 {
                    imageView.loadImage(url: gallery[0].url)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    lazy var publishButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 16
        logInButton.backgroundColor = UIColor(hex: "7F3DFF")
        logInButton.setTitle("Publish", for: .normal)
        logInButton.tintColor = .white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        return logInButton
    }()
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func publishButtonTapped() {
        if textView.text.replacingOccurrences(of: " ", with: "").isEmpty {
            self.showAlert(title: "Warning", message: "Please write something to comment")
            return
        }
        view.endEditing(true)
        if let destionation = destionation {
            API.shared.addCommend(comment: textView.text, destination_ID: destionation.id) { [weak self] result in
                switch result {
                case .success(_):
                    API.shared.rateDestination(score: Int(self?.starRatingView.value ?? 0.0), destination_ID: destionation.id) { result in
                        switch result {
                        case .success(_):
                            self?.dismiss(animated: true)
                            self?.showAlert(title: "Success", message: "Your review successfully added")
                        case .failure(_):
                            self?.showAlert(title: "Error", message: "Something went wrong")
                        }
                    }
                case .failure(_):
                    self?.showAlert(title: "Error", message: "Something went wrong")
                }
            }
        }
    }

    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(30)
            make.height.width.equalTo(50)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(imageView)
        }
        
        subView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(imageView)
        }
        
        subView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        configureStarView()
        
        subView.addSubview(yourComments)
        yourComments.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(starRatingView.snp.bottom).offset(20)
        }
        
        subView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(yourComments.snp.bottom).offset(20)
            make.height.equalTo(150)
        }
        
        subView.addSubview(publishButton)
        publishButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-getBottomMargin() - 20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
    }
    
    func configureStarView() {
        starRatingView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.backgroundColor = UIColor.clear
        starRatingView.value = 0
        starRatingView.tintColor = UIColor.mainColor
        starRatingView.allowsHalfStars = false
//        starRatingView.addTarget(self, action: #selector(starValueChanged), for: .valueChanged)
        subView.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            publishButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-keyboardHeight - 10)
            }
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        publishButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-getBottomMargin() - 20)
        }
        view.layoutIfNeeded()
    }
}

extension CommentsViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
//        if contentHeight > UIWindow().bounds.height {
//            return .maxHeight
//        }
        return .maxHeightWithTopInset(50)
    }

    var shortFormHeight: PanModalHeight {
//        if contentHeight > UIWindow().bounds.height {
//            return .maxHeight
//        }
        return .maxHeightWithTopInset(50)
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}
