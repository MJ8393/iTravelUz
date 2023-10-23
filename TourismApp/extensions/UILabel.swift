//
//  UILabel.swift
//  TourismApp
//
//  Created by Nuriddinov Subkhiddin on 26/09/23.
//

import Foundation
import UIKit

extension UILabel {
    func config(font: UIFont?, color: UIColor?, numberOfLines: Int?, textAlignment: NSTextAlignment?) {
        if let f = font {
            self.font = f
        }
        
        if let color = color {
            self.textColor = color
        }
        
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        
        if let textAllignment = textAlignment {
            self.textAlignment = textAllignment
        }
    }
}

