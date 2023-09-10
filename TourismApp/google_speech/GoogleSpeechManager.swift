//
//  GoogleSpeechManager.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 10/09/23.
//

//import Foundation
//import AVFoundation
//import googleapis


//class GoogleSpeechManager: NSObject {
//
//    var audioData: NSMutableData!
//
//    let SAMPLE_RATE = 16000
//
//    class func startRecording() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSession.Category.record)
//        } catch {
//
//        }
//        audioData = NSMutableData()
//        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
//        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
//        _ = AudioController.sharedInstance.start()
//    }
//
//    class func stopRecording() {
//        _ = AudioController.sharedInstance.stop()
//        SpeechRecognitionService.sharedInstance.stopStreaming()
//    }
//
//    func processSampleData(_ data: Data) -> Void {
//      audioData.append(data)
//
//      // We recommend sending samples in 100ms chunks
//      let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
//        * Double(SAMPLE_RATE) /* samples/second */
//        * 2 /* bytes/sample */);
//
//      if (audioData.length > chunkSize) {
//        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
//                                                                completion:
//          { [weak self] (response, error) in
//              guard let strongSelf = self else {
//                  return
//              }
//
//              if let error = error {
////                  strongSelf.textView.text =
//                  print("Error", error.localizedDescription)
//              } else if let response = response {
//                  var finished = false
//                  print(response)
//                  for result in response.resultsArray! {
//                      if let result = result as? StreamingRecognitionResult {
//                          if result.isFinal {
//                              finished = true
//                          }
//                      }
//                  }
////                  strongSelf.textView.text = response.description
//                  print("XXXXX", response.description)
//
//                  if finished {
//                      strongSelf.stopAudio(strongSelf)
//                  }
//              }
//        })
//        self.audioData = NSMutableData()
//      }
//    }
//}
