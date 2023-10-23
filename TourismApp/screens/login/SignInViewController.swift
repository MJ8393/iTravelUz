//
//  SignInViewController.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 27/09/23.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star1")
        return imageView
    }()
    
    private let teamLbl: UILabel = {
        let teamLbl = UILabel()
        teamLbl.config(font: UIFont.boldSystemFont(ofSize: 30), color: UIColor.black, numberOfLines: 2, textAlignment: .none)
        teamLbl.text = "Log in"
        teamLbl.textColor = .label
        return teamLbl
    }()
    
    private let titleLabel1: UILabel = {
        let titleLabel = UILabel()
        titleLabel.config(font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor.black, numberOfLines: 1, textAlignment: .left)
        titleLabel.text = "Username"
        titleLabel.textColor = .label
        return titleLabel
    }()
        
    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        textField.placeholder = "Enter your username"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor.systemGray5
        return textField
    }()
    
    private let titleLabel2: UILabel = {
        let titleLabel = UILabel()
        titleLabel.config(font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor.black, numberOfLines: 1, textAlignment: .left)
        titleLabel.text = "Password"
        titleLabel.textColor = .label
        return titleLabel
    }()
        
    private let textField2: CustomizedTextField = {
        let textField = CustomizedTextField()
        textField.placeholder = "Enter your password"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor.systemGray5
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 16
        logInButton.backgroundColor = UIColor(hex: "7F3DFF")
        logInButton.setTitle("Log in", for: .normal)
        logInButton.tintColor = .white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return logInButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gessture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gessture)
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(teamLbl)
        view.addSubview(titleLabel1)
        view.addSubview(textField1)
        view.addSubview(titleLabel2)
        view.addSubview(textField2)
        view.addSubview(logInButton)
        
        
        
        imageView.snp.remakeConstraints { make in
            make.width.equalTo(46)
            make.height.equalTo(44)
            make.trailing.equalToSuperview().offset(-27)
            make.top.equalToSuperview().offset(60)
        }
        
        teamLbl.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel1.snp.remakeConstraints { make in
            make.top.equalTo(teamLbl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        textField1.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        titleLabel2.snp.remakeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
                
        textField2.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
           
        }
        
        
    }
    
    @objc func logInButtonTapped() {
//        API.shared.login(username: "aslon", password: "aslon2001") { result in
//            switch result {
//            case .success(_):
//                print("xxx")
//            case.failure(let error):
//                print(error)
//            }
//        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}

class CustomizedTextField: UITextField {
    
    let placeholderInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    let textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
}
