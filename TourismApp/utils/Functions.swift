//
//  Functions.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 21/10/23.
//

import UIKit

enum DeviceMode {
    case light
    case dark
    case noMode
}

class Functions {
    static func getDeviceMode() -> DeviceMode {
        if #available(iOS 12.0, *) {
            let currentTraitCollection = UIScreen.main.traitCollection
            if currentTraitCollection.userInterfaceStyle == .light {
                return DeviceMode.light
            } else {
                return DeviceMode.dark
            }
        } else {
            return DeviceMode.light
        }
    }
}
