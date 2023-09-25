//
//  File.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 13/08/23.
//

import Foundation

let UD = UserDefaults(suiteName: "uz.carwon.www")!

extension UserDefaults {
    var conversationID: String? {
        get { return self.string(forKey: "favorites") }
        set { self.set(newValue, forKey: "favorites") }
    }
    
    var favorites: [String]? {
        get { return self.stringArray(forKey: "favorites") }
        set { self.set(newValue, forKey: "favorites") }
    }
    
}
