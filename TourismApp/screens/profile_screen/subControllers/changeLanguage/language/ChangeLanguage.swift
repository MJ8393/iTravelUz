//
//  ChangeLanguage.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 27/09/23.
//

import UIKit
import PanModal

struct Language {
    let image: UIImage
    let name: String
    let language: AppLanguage
}

struct Mode {
    let image: UIImage
    let name: String
    let mode: AppMode
}

enum AppMode {
    case dark
    case light
    case system
}

let languages: [Language] = [
    Language(image: UIImage(named: "us")!, name: "english".translate(), language: .English),
    Language(image: UIImage(named: "uz")!, name: "uzbek".translate(), language: .Uzbek)
]

let modes: [Mode] = [
    Mode(image: UIImage(systemName: "cloud.moon")!, name: "dark".translate(), mode: .dark),
    Mode(image:  UIImage(systemName: "sun.max")!, name: "light".translate(), mode: .light),
    Mode(image:  UIImage(systemName: "iphone.gen1")!, name: "system".translate(), mode: .system)
]

class ChangeLanguage: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var isModeChange: Bool = false
    
    var contentHeight = 250.0
    
    lazy var chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose language"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChangeLanguageCell.self, forCellReuseIdentifier: String.init(describing: ChangeLanguageCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentHeight()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(chooseLanguageLabel)
        chooseLanguageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(25)
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(chooseLanguageLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        if isModeChange {
            chooseLanguageLabel.text = "choose_language".translate()
        } else {
            chooseLanguageLabel.text = "choose_mode".translate()
        }
    }
    
    private func setContentHeight() {
        self.contentHeight = tableView.contentSize.height + 25 + 22 + 20
        self.panModalSetNeedsLayoutUpdate()
        self.panModalTransition(to: .shortForm)
    }

}

extension ChangeLanguage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isModeChange {
            return modes.count
        }
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChangeLanguageCell.self), for: indexPath) as? ChangeLanguageCell else { return UITableViewCell() }
        if isModeChange {
            cell.setMode(mode: modes[indexPath.row], index: indexPath.row)
            cell.iconImageView.tintColor = .label
            if indexPath.row == getChoosedIndex() {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        } else {
            cell.setData(language: languages[indexPath.row])
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func getChoosedIndex() -> Int {
        let mode = UD.mode
        var index = 0
        if mode == "light" {
            index = 1
        } else if mode == "dark" {
            index = 0
        } else {
            index = 2
        }
        return index
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isModeChange {
            if indexPath.row == 0 {
                UD.mode = "dark"
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            } else if indexPath.row == 1 {
                UD.mode = "light"
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            } else {
                UD.mode = "system"
                let deviceMode = Functions.getDeviceMode()
                if deviceMode == .light {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                } else if deviceMode == .dark {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                } else {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                }
            }
        } else {
            let language = languages[indexPath.row]
            LanguageManager.setApplLang(language.language)
            tableView.reloadData()
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
        }
        dismiss(animated: true)
    }
}

extension ChangeLanguage: PanModalPresentable {

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
