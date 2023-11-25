//
//  ViewController.swift
//  Translator
//
//  Created by Mekhriddin Jumaev on 31/10/23.
//

import UIKit
import SnapKit
import AVFoundation

class TranslatorViewController: BaseViewController, AudioControllerDelegate {
    
    var languages = [String: String]()
    
    var isRecording: Bool = false {
        didSet {
            if isRecording {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
                    cell.microphoneButton.tintColor = .mainColor
                }
            } else {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
                    cell.microphoneButton.tintColor = .label
                    cell.updateText()
                }
            }
        }
    }
    
    var audioData: NSMutableData!
    
    let SAMPLE_RATE = 16000
    
    var recorder:AVAudioRecorder!


    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.register(TranslatorTableViewCell.self, forCellReuseIdentifier: String.init(describing: TranslatorTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    let topView = TopView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        initViews()
//        getAllLanguages()
        setEnglishUzbek()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
        AudioController.sharedInstance.delegate = self
    }
    
    override func languageDidChange() {
        title = "translator".translate()
        self.languages["uz"] = "uzbek".translate()
        self.languages["en"] = "english".translate()
        tableView.reloadData()
    }
    
    func setEnglishUzbek() {
        if UD.to == nil || UD.to == "" {
            UD.to = "uz"
        }
        
        if UD.from == nil || UD.from == "" {
            UD.from = "en"
        }
        
        self.languages["uz"] = "uzbek".translate()
        self.languages["en"] = "english".translate()
        self.tableView.reloadData()
    }
    
    func getAllLanguages() {
        showLoadingView()
        if UD.to == nil || UD.to == "" {
            UD.to = "uz"
        }
        
        if UD.from == nil || UD.from == "" {
            UD.from = "en"
        }
        
        self.languages["uz"] = "uzbek".translate()
        self.languages["en"] = "english".translate()
        SwiftGoogleTranslate.shared.languages { (languages, error) in
            self.dissmissLoadingView()
          if let languages = languages {
            for language in languages {
                self.languages[language.language] = language.name
            }
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
        }
    }
    
    private func setupNavigation() {
        view.backgroundColor = .systemBackground
        title = "translator".translate()
//        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .done, target: self, action: #selector(rightBarButtonTapped))
//        rightBarButton.tintColor = .white
//        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func rightBarButtonTapped() {
        
    }
    
    @objc func leftBarButtonTapped() {
        
    }
}

extension TranslatorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: TranslatorTableViewCell.self), for: indexPath) as? TranslatorTableViewCell else { return TranslatorTableViewCell() }
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        cell.selectionStyle = .none
        if indexPath.row == 1 {
            cell.clearButton.setImage(UIImage(systemName: "doc.on.doc")!, for: .normal)
            cell.type = .sender
            cell.microphoneButton.setImage(UIImage(systemName: "bookmark")!, for: .normal)
            cell.mainLabel.isUserInteractionEnabled = false
        } else {
            cell.mainLabel.isUserInteractionEnabled = true
            cell.type = .reciever
        }
        
        cell.setTopCornerRadius()
   
        if indexPath.row == 0 && UD.from == "uz" {
            cell.voiceButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else if indexPath.row == 0 && UD.from == "en" {
            cell.voiceButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        }
        
        if indexPath.row == 1 && UD.to == "uz" {
            cell.voiceButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else if indexPath.row == 1 && UD.to == "en" {
            cell.voiceButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        }
        
        if indexPath.row == 1 {
            cell.microphoneButton.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 3.2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        topView.delegate = self
        topView.languages = languages
        
        if let from = UD.from, from != "", !languages.isEmpty {
            topView.fromLabel.text = languages[from]
        }
        
        if let to = UD.to, to != "", !languages.isEmpty {
            topView.toLabel.text = languages[to]
        }
        
        return topView
    }
}

extension TranslatorViewController: TranslateTableViewDelegate, TopViewDelegate {
    func translatedText(_ text: String) {
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TranslatorTableViewCell {
                cell.mainLabel.text = text
            }
        }
    }

    func clearButtonTapped() {
        let pasteboard = UIPasteboard.general
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
            pasteboard.string = cell.mainLabel.text ?? ""
        }
    }
    
    func copyButtonTapped() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
            cell.mainLabel.text = ""
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TranslatorTableViewCell {
            cell.mainLabel.text = ""
        }
        view.endEditing(true)
    }
    
    func microphoneTapped() {
        print("Micro")
        // Bookmark tapped
        
        
        
    }
    
    func speaker1Tapped() {
        // To speak
        
        // get to text
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TranslatorTableViewCell {
            if let text = cell.mainLabel.text {
                if UD.to == "en" {
                    SpeechService.shared.speak(text: text) {
                        
                    }
                } else {
                    // uzbek
                }
            }
        }
    }
    
    func speaker2Tapped() {
        // From speak
        
        // get from text
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
            if let text = cell.mainLabel.text {
                if UD.from == "en" {
                    SpeechService.shared.speak(text: text) {
                        
                    }
                } else {
                    // uzbek
                }
            }
        }
    }
        
    func bookmarkTapped() {
        
        // Microphone tapped
        
        isRecording = !isRecording
        if isRecording {
            startAudio()
            setupRecorder()
        } else {
            stopAudio()
//                stopRecording()
        }
    }
    
    func fromLabelTapped() {
//        let vc = CountriesListViewController()
//        vc.delegate = self
//        vc.isTo = false
//        vc.languages = languages
//        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func toLabelTapped() {
//        let vc = CountriesListViewController()
//        vc.delegate = self
//        vc.isTo = true
//        vc.languages = languages
//        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func exchangeTapped() {
        if let from = UD.from, from != "", let to = UD.to, to != "" {
            UD.from = to
//            topView.fromLabel.text = languages[to]
            UD.to = from
//            topView.toLabel.text = languages[from]
            tableView.reloadData()
            
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
                cell.updateText()
            }
        }
    }
}

extension TranslatorViewController: CountriesListDelegate {
    func didSelectCountry(key: String) {
        if let from = UD.from, from != "", !languages.isEmpty {
            topView.fromLabel.text = languages[from]
        }
        
        if let to = UD.to, to != "", !languages.isEmpty {
            topView.toLabel.text = languages[to]
        }
    }

}

extension TranslatorViewController {
    func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        SpeechRecognitionService.sharedInstance.isTranslatePage = true
        if UD.from == "uz" {
            SpeechRecognitionService.sharedInstance.translatorLang = "uz-UZ"
        } else {
            SpeechRecognitionService.sharedInstance.translatorLang = "en-US"
        }
        _ = AudioController.sharedInstance.start()
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
    
    @objc func setupRecorder() {
        if(checkMicPermission()) {
            startRecording()
        } else {
            print("permission denied")
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
    
    private func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        let recorderSettings = [AVSampleRateKey: NSNumber(value: 44100.0),
                                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                                AVNumberOfChannelsKey: NSNumber(value: 2),
                                AVEncoderAudioQualityKey: NSNumber(value: Int8(AVAudioQuality.min.rawValue))]
        
        let url: URL = URL(fileURLWithPath:"/dev/null")
        do {
            
            let displayLink: CADisplayLink = CADisplayLink(target: self,
                                                           selector: #selector(TranslatorViewController.updateMeters))
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
    
    private func showErrorPopUp(errorMessage: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
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
                  
                  print(transcript)
                  
                  if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TranslatorTableViewCell {
                      cell.mainLabel.text = transcript
                  }
                  
                  if finished {
                      self?.isRecording = false
                      self?.stopAudio()
                      self?.stopRecording()
                  }
              }
        })
        self.audioData = NSMutableData()
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
}

