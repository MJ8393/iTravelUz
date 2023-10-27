//
//  RegisterViewController.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 27/09/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star1")
        return imageView
    }()
    
    private let teamLbl: UILabel = {
        let teamLbl = UILabel()
        teamLbl.config(font: UIFont.boldSystemFont(ofSize: 30), color: UIColor.black, numberOfLines: 2, textAlignment: .none)
        teamLbl.text = "register".translate()
        teamLbl.textColor = .label
        return teamLbl
    }()
    
    private let titleLabel1: UILabel = {
        let titleLabel = UILabel()
        titleLabel.config(font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor.black, numberOfLines: 1, textAlignment: .left)
        titleLabel.text = "username".translate()
        titleLabel.textColor = .label
        return titleLabel
    }()
        
    private let textField1: CustomizedTextField = {
        let textField = CustomizedTextField()
        textField.placeholder = "enter_username".translate()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor.systemGray5
        return textField
    }()
    
    private let titleLabel2: UILabel = {
        let titleLabel = UILabel()
        titleLabel.config(font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor.black, numberOfLines: 1, textAlignment: .left)
        titleLabel.text = "parol".translate()
        titleLabel.textColor = .label
        return titleLabel
    }()
        
    private let textField2: CustomizedTextField = {
        let textField = CustomizedTextField()
        textField.placeholder = "enter_password".translate()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor.systemGray5
        return textField
    }()
    
    private let titleLabel3: UILabel = {
        let titleLabel = UILabel()
        titleLabel.config(font: UIFont.systemFont(ofSize: 16, weight: .medium), color: UIColor.black, numberOfLines: 1, textAlignment: .left)
        titleLabel.text = "email".translate()
        titleLabel.textColor = .label
        return titleLabel
    }()
        
    private let textField3: CustomizedTextField = {
        let textField = CustomizedTextField()
        textField.placeholder = "enter_email".translate()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor.systemGray5
        return textField
    }()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 16
        logInButton.backgroundColor = UIColor(hex: "7F3DFF")
        logInButton.setTitle("register".translate(), for: .normal)
        logInButton.tintColor = .white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return logInButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gessture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gessture)
        view.backgroundColor = .systemBackground
        logInButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(teamLbl)
        view.addSubview(titleLabel1)
        view.addSubview(textField1)
        view.addSubview(titleLabel2)
        view.addSubview(textField2)
        view.addSubview(titleLabel3)
        view.addSubview(textField3)
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
        
        titleLabel3.snp.remakeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
                
        textField3.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel3.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
           
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func signUpTapped() {
        checkData()
    }
    
    func checkData() {
        if let username = textField1.text?.replacingOccurrences(of: " ", with: "") {
            if username.count < 5 {
                showAlert(message: "Username should contains at least 5 characters")
                return
            }
        }
        
        if let password = textField2.text?.replacingOccurrences(of: " ", with: "") {
            if password.count < 5 {
                showAlert(message: "Password should contains at least 5 characters")
                return
            }
//            } else if !containsNumber(in: password) {
//                showAlert(message: "Password should contains at least 1 digit")
//                return
//            }
        }
        
        if let email = textField3.text?.replacingOccurrences(of: " ", with: "") {
            if !isValidEmail(email) {
                showAlert(message: "Your email is not valid")
                return
            }
        }
        
        if let username = textField1.text, let password = textField2.text, let email = textField3.text {
            self.showLoadingView()
            API.shared.signUp(username: username, password: password, email: email) { [weak self] result in
                switch result {
                case .success(_):
                    API.shared.login(username: username, password: password) { [weak self] result in
                        switch result {
                        case .success(let data):
                            UD.token = data.Authorization
                            UD.username = username
                            let seconds = 0.5
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                self?.dissmissLoadingView()
                                self?.setNewRootViewController()
                            }
                        case.failure(let error):
                            self?.showAlert(title: "Error", message: "Something went wrong")
                            print(error)
                        }
                    }
                case .failure(_):
                    self?.showAlert(message: "Can not register. Please check your data")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func containsNumber(in inputString: String) -> Bool {
        let numberRegex = ".*[0-9]+.*"
        let range = NSRange(location: 0, length: inputString.utf16.count)
        
        if let regex = try? NSRegularExpression(pattern: numberRegex) {
            return regex.firstMatch(in: inputString, options: [], range: range) != nil
        }
        
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
