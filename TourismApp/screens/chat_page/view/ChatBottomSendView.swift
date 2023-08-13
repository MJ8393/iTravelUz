//
//  ChatBottomSendView.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit

class ChatBottomSendView: UIView {
    
    var callback: (() -> Void)?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.chatGrayColor
        view.layer.cornerRadius = 45.0 / 2
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        let placeholderText = "Enter your text"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeHolderColor,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let attributedText = NSAttributedString(string: "", attributes: attributes2)
        textField.attributedText = attributedText
        textField.tintColor = UIColor.mainColor
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 45.0 / 2
        button.backgroundColor = UIColor.mainColor
        button.setImage(UIImage(named: "send_icon")!, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        openChat()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openChat() {
        API.shared.openChat { [weak self] result in
            switch result {
            case .success(let chatData):
                print("xxxx")
                UD.conversationID = chatData.conversationId
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func initViews() {
        self.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(45)
        }
        
        subView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.right.equalTo(sendButton.snp.left).offset(-16)
        }
        
        containerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
        
    @objc func sendButtonTapped() {
        callback?()
    }
    
    func getText() -> String? {
        if let text = textField.text {
            return text
        }
        return ""
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
}
