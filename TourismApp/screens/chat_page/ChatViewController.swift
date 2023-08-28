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
    
    var messages = [Message]()

    
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
        print("Get Chat History")
        getChatHistory()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Closing chat")
        closeChat()
    }
    
    private func setupNavigation() {
        title = "AI Travel Assistent"
        navigationController?.navigationBar.tintColor = .black
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
            self?.questionAsked()
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
    
    func openChat() {
        showLoadingView()
        API.shared.openChat { [weak self] result in
            self?.dissmissLoadingView()
            switch result {
            case .success(let chatData):
                UD.conversationID = chatData.conversationId
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func askQuestion(_ question: String) {
        API.shared.queryChat(question: question) { [weak self] result in
            switch result {
            case .success(let data):
                self?.bottomSendView.hideLoadingView()
                self?.insertCell(str: data.answer, type: .recieved)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func closeChat() {
        API.shared.closeChat { result in
            switch result {
            case .success(let data):
                UD.conversationID = ""
                print(data.message)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getChatHistory() {
        showLoadingView()
        API.shared.getChatHistory { [weak self] result in
            self?.dissmissLoadingView()
            switch result {
            case .success(let data):
                self?.setData(data.conversations)
                self?.tableView.reloadData()
                self?.openChat()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setData(_ conversations: [Conversation]) {
        for conversation in conversations {
            var i = 0
            for context in conversation.ChatHistory {
                let context = context.Context
                var type: MessageType = .sended
                if i % 2 == 1 {
                    type = .recieved
                }
                messages.append(Message(text: context, type: type))
                i += 1
            }
        }
    }
    
    func questionAsked() {
        if let newMessage = bottomSendView.getText(), !newMessage.isEmpty {
            askQuestion(newMessage)
            insertCell(str: newMessage, type: .sended)
        }
        bottomSendView.setText("")
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
    
    func insertCell(str: String, type: MessageType) {
        messages.append(Message(text: str, type: type))
        let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        tableView.reloadRows(at: [newIndexPath], with: .bottom)
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
