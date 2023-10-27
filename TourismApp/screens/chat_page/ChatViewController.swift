//
//  ChatViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit
import googleapis
import AVFoundation
import AVKit


class ChatViewController: UIViewController, ChatControllerDelegate {
    
    // MARK: Properties
    var isRecording: Bool = false
    
    var audioData: NSMutableData!
    
    let SAMPLE_RATE = 16000
    
    private var recorder:AVAudioRecorder!
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var messages = [Message]()

    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorStyle = .none
        tableView.register(ChatSenderCell.self, forCellReuseIdentifier: String.init(describing: ChatSenderCell.self))
        tableView.register(ChatRecieverCell.self, forCellReuseIdentifier: String.init(describing: ChatRecieverCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tap)
        return tableView
    }()
    
    lazy var bottomSendView: ChatBottomSendView = {
        let view = ChatBottomSendView()
        view.delegate = self
        return view
    }()
    
    private var siriWave: SiriWaveView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        initViews()
        addObservers()
        AudioController.sharedInstance.delegate = self
        getChatHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var chatLanguage: String = "english"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMicPermission()
        
        let languague = LanguageManager.getAppLang()
        switch languague {
        case .English:
            chatLanguage = "english"
        case .Uzbek:
            chatLanguage = "uzbek"
        case .lanDesc:
            chatLanguage = "english"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        closeChat()
        SpeechService.shared.stopPlaying()
    }
    
    private func setupNavigation() {
        title = "ai_assistent".translate()
    }
    
    private func initViews() {
        view.backgroundColor = UIColor(named: "tabbar")
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomSendView)
        
        bottomSendView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0)
            make.left.right.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomSendView.snp.top)
        }
        
        siriWave = SiriWaveView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 120))
        siriWave.backgroundColor = .clear
        view.addSubview(siriWave)
    }
    
    func openChat() {
        showLoadingView()
        print("xxxxx", chatLanguage)
        
        API.shared.openChat(language: chatLanguage) { [weak self] result in
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
        self.bottomSendView.sendButton.showLoader(userInteraction: false)
        self.bottomSendView.sendButton.isUserInteractionEnabled = false
        API.shared.queryChat(question: question, language: chatLanguage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.bottomSendView.hideLoadingView()
                self?.insertCell(str: data.answer, type: .recieved)
                self?.bottomSendView.sendButton.isUserInteractionEnabled = false
                SpeechService.shared.speak(text: data.answer) {
                    self?.bottomSendView.sendButton.isUserInteractionEnabled = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func closeChat() {
        print("yyyyyy", chatLanguage)
        
        API.shared.closeChat(language: chatLanguage) { result in
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
                self?.scrollToBottom()
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
    
    func microphoneTapped() {
        isRecording = !isRecording
        if isRecording {
            startAudio()
            showWaveView()
            setupRecorder()
            bottomSendView.textField.isUserInteractionEnabled = false
        } else {
            bottomSendView.textField.isUserInteractionEnabled = true
            stopAudio()
            closeWaveView()
            stopRecording()
        }
    }
    
    func sendButtonTapped() {
        if let newMessage = bottomSendView.getText(), !newMessage.replacingOccurrences(of: " ", with: "").isEmpty {
            askQuestion(newMessage)
            insertCell(str: newMessage, type: .sended)
            bottomSendView.setText("")
        }
    }
    
    
    func showWaveView() {
        sifiOpened = true
        if isRecording {
            view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSendView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-self.getBottomMargin() - 120.0)
            }
            self.siriWave.frame.origin.y = UIScreen.main.bounds.height - (110.0 + 2 * self.getBottomMargin())
            self.view.layoutIfNeeded()
        })
        scrollToBottom()
    }
    
    var sifiOpened: Bool = false
    
    func closeWaveView() {
        sifiOpened = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSendView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
            self.siriWave.frame.origin.y = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        })
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
                    make.bottom.equalToSuperview().offset(-keyboardHeight + self.getBottomMargin())
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func tableViewTapped() {
        if sifiOpened {
            isRecording = false
            bottomSendView.textField.isUserInteractionEnabled = true
            stopAudio()
            closeWaveView()
            stopRecording()
        }
        view.endEditing(true)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if isRecording { return }
        UIView.animate(withDuration: 0.3) {
            self.bottomSendView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        scrollToBottom()
    }
    
    func scrollToBottom() {
        if tableView.numberOfRows(inSection: 0) - 1 <= 0 { return }
        let lastIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    func insertCell(str: String, type: MessageType) {
        messages.append(Message(text: str, type: type))
        let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .fade)
        tableView.endUpdates()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
//        tableView.reloadRows(at: [newIndexPath], with: .fade)
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

// MARK: Google Cloud Services
extension ChatViewController: AudioControllerDelegate {

    func processSampleData(_ data: Data) -> Void {
      audioData.append(data)

      // We recommend sending samples in 100ms chunks
      let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
        * Double(SAMPLE_RATE) /* samples/second */
        * 2 /* bytes/sample */);

      if (audioData.length > chunkSize) {
        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                completion:
          { [weak self] (response, error) in
              guard let strongSelf = self else {
                  return
              }
              
              if let error = error {
//                  strongSelf.textView.text = error.localizedDescription
              } else if let response = response {
                  var finished = false
                  var transcript: String = ""
                  var confidence: Float = 0.0
//                  print(response)
                  for result in response.resultsArray! {
                      if let result = result as? StreamingRecognitionResult {
                          if let alternativesArray = result.alternativesArray as? [SpeechRecognitionAlternative] {
                              for alternative in alternativesArray {
                                  if confidence <= alternative.confidence {
                                      transcript = alternative.transcript
                                      confidence = alternative.confidence
                                  }
                              }
                          }
                          if result.isFinal {
                              finished = true
                          }
                      }
                  }

                  self?.bottomSendView.textField.text = transcript
                  if finished {
                      self?.isRecording = false
                      self?.sendButtonTapped()
                      self?.stopAudio()
                      self?.bottomSendView.textField.isUserInteractionEnabled = true
                      self?.closeWaveView()
                      self?.stopRecording()
                  }
              }
        })
        self.audioData = NSMutableData()
      }
    }
    
    func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
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

extension ChatViewController {
    
    @objc func setupRecorder() {
        if(checkMicPermission()) {
            startRecording()
        } else {
            print("permission denied")
        }
    }
    
    @objc func stopRecording() {
        if self.recorder != nil && self.recorder.isRecording {
            self.recorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                print("Error deactivating audio session: \(error.localizedDescription)")
            }
            print("Recording stopped")
        } else {
            print("No active recording to stop")
        }
    }
    
    @objc func updateMeters() {
        var normalizedValue: Float
        recorder.updateMeters()
        normalizedValue = normalizedPowerLevelFromDecibels(decibels: recorder.averagePower(forChannel: 0))
        // Adjust the animation speed based on the microphone input amplitude.
        let speed = CGFloat(0.05 + normalizedValue * 0.1) // Adjust the coefficients as needed
        self.siriWave.update(CGFloat(normalizedValue) * 10)
    }
    
    private func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        let recorderSettings = [AVSampleRateKey: NSNumber(value: 44100.0),
                                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                                AVNumberOfChannelsKey: NSNumber(value: 2),
                                AVEncoderAudioQualityKey: NSNumber(value: Int8(AVAudioQuality.min.rawValue))]
        
        let url: URL = URL(fileURLWithPath:"/dev/null")
        do {
            
            let displayLink: CADisplayLink = CADisplayLink(target: self,
                                                           selector: #selector(ChatViewController.updateMeters))
            displayLink.add(to: RunLoop.current,
                            forMode: RunLoop.Mode.common)

            try recordingSession.setCategory(.playAndRecord,
                                             mode: .default)
            try recordingSession.setActive(true)
            self.recorder = try AVAudioRecorder.init(url: url,
                                                     settings: recorderSettings as [String : Any])
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true;
            self.recorder.record()
            print("recorder enabled")
        } catch {
            self.showErrorPopUp(errorMessage: error.localizedDescription)
            print("recorder init failed")
        }
    }
    
    private func checkMicPermission() -> Bool {
        var permissionCheck: Bool = false
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        
        return permissionCheck
    }
    
    private func normalizedPowerLevelFromDecibels(decibels: Float) -> Float {
        let minDecibels: Float = -60.0
        if (decibels < minDecibels || decibels.isZero) {
            return .zero
        }
        
        let powDecibels = pow(10.0, 0.05 * decibels)
        let powMinDecibels = pow(10.0, 0.05 * minDecibels)
        return pow((powDecibels - powMinDecibels) * (1.0 / (1.0 - powMinDecibels)), 1.0 / 2.0)
        
    }
    
    private func showErrorPopUp(errorMessage: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
