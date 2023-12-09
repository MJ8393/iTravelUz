//
//  CheckInternet.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/12/23.
//

import UIKit
import Alamofire

protocol NetworkMonitorDelegate: AnyObject {
    func checkInternetConnection(isOnline: Bool)
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    weak var delegate: NetworkMonitorDelegate?
    
    private let queue = DispatchQueue.main
    
    var timer: Timer?

    // Start monitoring
    public func startMonitoring() {
        queue.async {
            self.startTimer()
        }
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkNetwork), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkNetwork() {
        onCheckConnection(status: isConnectedToNetwork())
    }
    
    func onCheckConnection(status: Bool) {
        if status {
            delegate?.checkInternetConnection(isOnline: true)
        } else {
            delegate?.checkInternetConnection(isOnline: false)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // Stop monitoring
    public func stopMonitoring() {
        queue.async {
            self.stopTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
