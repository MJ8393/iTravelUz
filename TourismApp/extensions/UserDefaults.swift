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
    
    public var language: String {
        get { return unarchiveObject(key: "appLanguage").notNullString }
        set { archivedData(key: "appLanguage", object: newValue )    }
    }

    var mode: String? {
        get { return self.string(forKey: "appMode") }
        set { self.set(newValue, forKey: "appMode") }
    }
    
    func unarchiveObject(key: String) -> Any? {
        if let data = value(forKey: key) as? Data {
                do {
                    if let result = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self, NSNumber.self], from: data) {
                        return (result as AnyObject).value(forKey: "Data")
                    }
                }
            return nil
        }
        return nil
    }
    
    func archivedData(key: String, object: Any) {
        let result = NSMutableDictionary()
        result.setValue(object, forKey: "Data")
            do {
                let encodedObject = try? NSKeyedArchiver.archivedData(withRootObject: result, requiringSecureCoding: false)
                set(encodedObject, forKey: key)
            }
    }
    
    var token: String? {
        get { return self.string(forKey: "token") }
        set { self.set(newValue, forKey: "token") }
    }
    
    var username: String? {
        get { return self.string(forKey: "token") }
        set { self.set(newValue, forKey: "token") }
    }
}

extension Optional {
    var notNullString: String {
        switch self {
        case .some(let value): return String(describing: value)
        case .none : return ""
        }
    }
}
