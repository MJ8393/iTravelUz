//
//  Login.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 26/09/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //    private let imageView : UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(named: "star")
    //        return imageView
    //    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "scanFor")
        return imageView
    }()
    
    
    private let logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.layer.cornerRadius = 16
        logInButton.backgroundColor = UIColor(hex: "7F3DFF")
        logInButton.setTitle("login".translate(), for: .normal)
        logInButton.tintColor = .white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return logInButton
    }()
    
    private let registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.layer.cornerRadius = 16
        registerButton.backgroundColor = .white
        registerButton.setTitle("create_account".translate(), for: .normal)
        registerButton.tintColor = .black
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return registerButton
    }()
    
    private let teamLbl: UILabel = {
        let teamLbl = UILabel()
        teamLbl.config(font: UIFont.systemFont(ofSize: 22, weight: .semibold), color: UIColor.black, numberOfLines: 2, textAlignment: .none)
        teamLbl.text = "GuideMe"
        teamLbl.textColor = .label
        teamLbl.isHidden = true
        return teamLbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        registerButton.addTarget(self, action: #selector(openRegisterViewController), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(openSignInViewController), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        addGradient()
        view.addSubview(logInButton)
        view.addSubview(registerButton)
        //            view.addSubview(imageView)
        //            view.addSubview(teamLbl)
        
        //        imageView.snp.makeConstraints { make in
        //            make.centerX.equalToSuperview()
        //            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        //            make.width.equalTo(315)
        //            make.height.equalTo(273)
        //        }
        
        //        teamLbl.snp.makeConstraints { make in
        //            make.centerX.equalToSuperview()
        //            make.top.equalToSuperview().offset(60)
        //        }
        
        
        logInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-150)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(55)
            
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(20)
            make.height.equalTo(55)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImageView.frame = view.bounds
    }
    
    @objc private func openRegisterViewController() {
        let registerVC = RegisterViewController()
        
        
        let navigationController = UINavigationController(rootViewController: registerVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")!, style: .plain, target: self, action: #selector(dismissRegisterViewController))
        backButton.tintColor = .label
        
        registerVC.navigationItem.leftBarButtonItem = backButton
        present(navigationController, animated: true, completion: nil)
        
    }
    
    @objc private func openSignInViewController() {
        let loginVC = SignInViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")!, style: .plain, target: self, action: #selector(dismissRegisterViewController))
        backButton.tintColor = .label
        
        loginVC.navigationItem.leftBarButtonItem = backButton
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc private func dismissRegisterViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    
}
