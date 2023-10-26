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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
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
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var isSpeechPlaying = false
    private var isSpeechPaused = false
    private var lastSpeechUtterance: AVSpeechUtterance?
    
    private var currentlySpokenWordRange: NSRange?
    
    private var attributedTextWithHighlighting: NSMutableAttributedString?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        speechSynthesizer.delegate = self // Set the delegate
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
            make.right.equalToSuperview().offset(-20)
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
    }
    
    func setData(_ title: String, _ description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    @objc func playButtonTapped() {
        if isSpeechPlaying {
            // Stop the speech and change the button image to "play.fill"
            speechSynthesizer.stopSpeaking(at: .immediate)
            let playIconImage = UIImage(systemName: "play.fill")
            playButton.setImage(playIconImage, for: .normal)
            
            // Reset the attributed text to the original attributed text without highlighting
            descriptionLabel.attributedText = attributedTextWithHighlighting
//            speechSynthesizer.pauseSpeaking(at: .immediate)
        } else {
            // Start speaking and change the button image to "stop.fill"
            let spokenText = descriptionLabel.text ?? ""
            let speechUtterance = AVSpeechUtterance(string: spokenText)
            print(spokenText, "xxx")
            speechSynthesizer.speak(speechUtterance)
            let stopIconImage = UIImage(systemName: "stop.fill")
            playButton.setImage(stopIconImage, for: .normal)
        }
        
        // Toggle the state
        isSpeechPlaying.toggle()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
                // Create attributed string with highlighted sentence
                let attributedText = NSMutableAttributedString(string: descriptionLabel.text ?? "")
                
                // Find the sentence containing the character range using regular expressions
                if let sentenceRange = findSentenceRange(text: descriptionLabel.text ?? "", characterRange: characterRange) {
                    attributedText.addAttribute(.backgroundColor, value: UIColor.mainColor.withAlphaComponent(0.5), range: sentenceRange)
                }
                
                // Store the attributed text with highlighting
                attributedTextWithHighlighting = attributedText
                
                // Apply attributed text to descriptionLabel
                descriptionLabel.attributedText = attributedText
            }
        
        func findSentenceRange(text: String, characterRange: NSRange) -> NSRange? {
            do {
                let regex = try NSRegularExpression(pattern: "[^.!?]+[.!?]", options: .anchorsMatchLines)
                let fullRange = NSRange(location: 0, length: text.utf16.count)
                let matches = regex.matches(in: text, options: [], range: fullRange)
                
                for match in matches {
                    let sentenceRange = match.range
                    if NSIntersectionRange(sentenceRange, characterRange).length > 0 {
                        return sentenceRange
                    }
                }
            } catch {
                print("Error in regular expression: \(error)")
            }
            
            return nil
        }
}
