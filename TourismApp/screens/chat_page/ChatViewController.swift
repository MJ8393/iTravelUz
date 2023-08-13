//
//  ChatViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit


class ChatViewController: UIViewController {
    
    // MARK: Properties
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(ChatSenderCell.self, forCellReuseIdentifier: String.init(describing: ChatSenderCell.self))
        tableView.register(ChatRecieverCell.self, forCellReuseIdentifier: String.init(describing: ChatRecieverCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var bottomSendView: ChatBottomSendView = {
        let view = ChatBottomSendView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        initViews()
        addObservers()
    }
    
    private func setupNavigation() {
        title = "AI Travel Assistent"
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomSendView)
        bottomSendView.callback = { [weak self] in
            self?.insertCell()
        }
        
        bottomSendView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-getBottomMargin())
            make.left.right.equalToSuperview()
        }

        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomSendView.snp.top)
        }
      
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
  
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.bottomSendView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomSendView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-self.getBottomMargin())
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        let lastIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    func insertCell() {
        if let newMessage = bottomSendView.getText(), !newMessage.isEmpty {
            messages.append(Message(text: newMessage, type: .sended))
            let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.endUpdates()
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            bottomSendView.setText("")
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.type {
        case .sended:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChatSenderCell.self), for: indexPath) as? ChatSenderCell else { return UITableViewCell() }
            cell.setData(text: message.text ?? "")
            return cell
        case .recieved:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChatRecieverCell.self), for: indexPath) as? ChatRecieverCell else { return UITableViewCell() }
            cell.setData(text: message.text ?? "")
            return cell
        }
    }
}

enum MessageType {
    case sended
    case recieved
}


struct Message {
    let text: String?
    let type: MessageType
}

var messages = [
    Message(text: "Hello, Who is Amir Timur?", type: .sended),
    Message(text: "Timur Taragay ibn Barlas was born on April 9, 1336 in the small village of Khoja-Ilgar. The name Temur is translated from Turkic as “iron”, which in many respects influenced his strong-willed character and further fate. He was a brave and courageous young man, his parents and mentors raised him as a real warrior. Despite the wound in the leg that he received in battle, he had remarkable strength and until the last days he personally participated in all campaigns and battles. Therefore, historians called him the Great Lame.", type: .recieved),
    Message(text: "Hello, Who is Amir Timur?", type: .sended),
    Message(text: "Timur Taragay ibn Barlas was born on April 9, 1336 in the small village of Khoja-Ilgar. The name Temur is translated from Turkic as “iron”, which in many respects influenced his strong-willed character and further fate. He was a brave and courageous young man, his parents and mentors raised him as a real warrior. Despite the wound in the leg that he received in battle, he had remarkable strength and until the last days he personally participated in all campaigns and battles. Therefore, historians called him the Great Lame.", type: .recieved),
]
