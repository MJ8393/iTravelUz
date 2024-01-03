//
//  Ext_String.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 28/09/23.
//

import Foundation

extension String {
    func translate() -> String {
        return self.localized()
    }
}

extension DestionationName {
    func getName() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.uzbek ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}

extension CityName {
    func getCityName() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.uzbek ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}

extension HotelName {
    func getName() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.uzbek ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}

extension RestaurantName {
    func getName() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.uzbek ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}

extension DescriptionString {
    func getDescription() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.uzbek ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}


extension CountryName {
    func getCountry() -> String {
        let language = LanguageManager.getAppLang()
        switch language {
        case .Uzbek:
            return self.arabic ?? ""
        case .English:
            return self.english ?? ""
        default:
            return ""
        }
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
