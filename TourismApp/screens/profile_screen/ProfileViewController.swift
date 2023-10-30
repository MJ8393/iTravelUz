//
//  ProfileViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 27/09/23.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String.init(describing: ProfileTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "profile".translate()
    }
    
    override func languageDidChange() {
        super.languageDidChange()
        title = "profile".translate()
        profiles = [
            Profile(image: UIImage(systemName: "info.circle")!, name: "my_info".translate()),
            Profile(image: UIImage(systemName: "network")!, name: "change_language".translate()),
            Profile(image: UIImage(systemName: "moon")!, name: "design".translate()),
            Profile(image: UIImage(systemName: "envelope")!, name: "share_feedback".translate()),
//            Profile(image: UIImage(systemName: "star")!, name: "rate_app".translate()),
            Profile(image: UIImage(systemName: "rectangle.portrait.and.arrow.right")!, name: "log_out".translate()),
        ]
        tableView.reloadData()
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.systemBackground
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.setData(profile: profiles[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = PersonalViewController()
            present(UINavigationController(rootViewController: vc), animated: true)
        case 1:
            let vc = ChangeLanguage()
            navigationController?.presentPanModal(vc)
        case 2:
            let vc = ChangeLanguage()
            vc.isModeChange = true
            navigationController?.presentPanModal(vc)
        case 3:
            let email = "guidemesaamteam@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
        case 4:
            let alertController = UIAlertController(title: "log_out".translate(), message: "log_out_alert".translate(), preferredStyle: .alert)
            
            // Create a Log Out action
            let logoutAction = UIAlertAction(title: "log_out".translate(), style: .destructive) { (action) in
                UD.token = ""
                UD.username = ""
                self.goLoginPage()
            }
            
            let cancelAction = UIAlertAction(title: "calcel".translate(), style: .cancel, handler: nil)
            alertController.addAction(logoutAction)
            alertController.addAction(cancelAction)
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
            // Log go log in screen
//            UD.
        default:
            print("xx")
            
        }
        
        
    }
    
}

var profiles = [
    Profile(image: UIImage(systemName: "info.circle")!, name: "my_info".translate()),
    Profile(image: UIImage(systemName: "network")!, name: "change_language".translate()),
    Profile(image: UIImage(systemName: "moon")!, name: "design".translate()),
    Profile(image: UIImage(systemName: "envelope")!, name: "share_feedback".translate()),
//    Profile(image: UIImage(systemName: "star")!, name: "rate_app".translate()),
    Profile(image: UIImage(systemName: "rectangle.portrait.and.arrow.right")!, name: "log_out".translate()),
]


struct Profile {
    let image: UIImage
    let name: String
}
