//
//  ExploreContentTableCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 09/09/23.
//

import UIKit
import AVFoundation

class ExploreContentTableCell: UITableViewCell, AVSpeechSynthesizerDelegate {
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var isSpeedStopped: Bool = true
    
    var uzbekVoices = [URL]()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        let playIconImage = UIImage(systemName: "play.fill")
        button.setImage(playIconImage, for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private var isSpeechPlaying = false
    private var isSpeechPaused = false
    private var lastSpeechUtterance: AVSpeechUtterance?
    
    private var currentlySpokenWordRange: NSRange?
    
    private var attributedTextWithHighlighting: NSMutableAttributedString?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20 - 40 - 10)
        }
        
        subView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        setLanguage()
    }
    
    func setLanguage() {
        let language = LanguageManager.getAppLang()
        switch language {
        case .English:
            playButton.isHidden = false
        case .Uzbek:
            playButton.isHidden = true
        case .lanDesc:
            playButton.isHidden = false
        }
    }
    
    func setData(_ title: String, _ description: String) {
        titleLabel.text = title
        let newText = description.replacingOccurrences(of: "\\n\\n", with: "\n\n\n")
        let newText2 = newText.replacingOccurrences(of: "\\n", with: "\n\n")
        descriptionLabel.text = newText2
    }
    
    func setTTS(tts: TTSModel) {
    }
    
    @objc func playButtonTapped() {
        if isSpeechPlaying {
            // Stop the speech and change the button image to "play.fill"
            let playIconImage = UIImage(systemName: "play.fill")
            playButton.setImage(playIconImage, for: .normal)
            SpeechService.shared.pausePlayer()
            isSpeechPlaying = false
            isSpeedStopped = false
        } else {
            if isSpeedStopped {
                // Start speaking and change the button image to "stop.fill"
                let spokenText = descriptionLabel.text ?? ""
                SpeechService.shared.speak(text: spokenText) {
    //                self?.bottomSendView.sendButton.isUserInteractionEnabled = true
                }
                
                let stopIconImage = UIImage(systemName: "stop.fill")
                playButton.setImage(stopIconImage, for: .normal)
                isSpeedStopped = false
            } else {
                let playIconImage = UIImage(systemName: "play.fill")
                playButton.setImage(playIconImage, for: .normal)
                SpeechService.shared.replay()
                isSpeedStopped = false
            }
            isSpeechPlaying = true
        }
    }
    
    func stopSpeech() {
        let playIconImage = UIImage(systemName: "play.fill")
        playButton.setImage(playIconImage, for: .normal)
        isSpeechPlaying.toggle()
        SpeechService.shared.stopPlaying()
        isSpeedStopped = true
    }
}
