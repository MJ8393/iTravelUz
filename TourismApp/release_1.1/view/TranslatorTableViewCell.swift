//
//  TranslatorTableViewCell.swift
//  Translator
//
//  Created by Mekhriddin Jumaev on 31/10/23.
//

import UIKit

protocol TranslateTableViewDelegate: AnyObject {
    func clearButtonTapped()
    func copyButtonTapped()
    func microphoneTapped()
    func speaker1Tapped()
    func speaker2Tapped()
    func bookmarkTapped()
    func translatedText(_ text: String)
}



enum TranslationType {
    case sender
    case reciever
}

class TranslatorTableViewCell: UITableViewCell, UITextViewDelegate {
    
    weak var delegate: TranslateTableViewDelegate?
    
    private var timer: Timer?
    
    var type: TranslationType = .sender
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "TranslateColor")
        return view
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(voiceButtonButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var microphoneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var mainLabel: UITextView = {
          let textView = UITextView()
          textView.font = UIFont.systemFont(ofSize: 20, weight: .medium)
          textView.textColor = .label
          textView.autocorrectionType = .no
          textView.textContainerInset = .zero
          textView.isScrollEnabled = true
          textView.isEditable = true // Enable editing
          textView.textContainerInset = .zero
          textView.backgroundColor = .clear
          textView.delegate = self
          textView.tintColor = .mainColor
          return textView
      }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        if type == .sender && UD.from == "uz" {
            voiceButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else {
            voiceButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        }
        
        if type == .reciever && UD.from == "en" {
            voiceButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else {
            voiceButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        }

        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        subView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(voiceButton)
        voiceButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(microphoneButton)
        microphoneButton.snp.makeConstraints { make in
            make.left.equalTo(voiceButton.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(microphoneButton.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setTopCornerRadius()  {
        // set bottom corner radius
        subView.layer.cornerRadius = 10
//        subView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setBottomCornerRadius()  {
        // set bottom corner radius
        subView.layer.cornerRadius = 10
//        subView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func hideXButton() {
        clearButton.isHidden = true
    }
    
    func hideMiccrophone() {
        microphoneButton.isHidden = true
    }
    
    @objc func clearButtonTapped() {
        switch type {
        case .sender:
            delegate?.clearButtonTapped()
        case .reciever:
            delegate?.copyButtonTapped()
        }
    }
    
    @objc func voiceButtonButtonTapped() {
        switch type {
        case .sender:
            delegate?.speaker1Tapped()
        case .reciever:
            delegate?.speaker2Tapped()
        }
    }
    
    @objc func microphoneTapped() {
        switch type {
        case .sender:
            delegate?.microphoneTapped()
        case .reciever:
            delegate?.bookmarkTapped()
        }
    }
    
    func updateText() {
        if let text = mainLabel.text {
            SwiftGoogleTranslate.shared.translate(text, UD.to ?? "uz", UD.from ?? "en") { (text, error) in
              if let t = text {
                print(t)
                  self.delegate?.translatedText(t)
              } else {
              }
            }
        }
    }
}

extension TranslatorTableViewCell {
    func textViewDidChange(_ textView: UITextView) {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.handleTranslationRequest()
        }
    }
    
    func handleTranslationRequest() {
        if let text = mainLabel.text {
            SwiftGoogleTranslate.shared.translate(text, UD.to ?? "uz", UD.from ?? "en") { (text, error) in
              if let t = text {
                print(t)
                  self.delegate?.translatedText(t)
              } else {
              }
            }
        }
       
    }
}
