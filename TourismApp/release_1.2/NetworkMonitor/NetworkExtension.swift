//
//  NetworkExtension.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 06/12/23.
//

import UIKit

extension UIViewController {
    func startMonitoring() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    func stopMonitoring() {
        NetworkMonitor.shared.stopMonitoring()
    }
}
