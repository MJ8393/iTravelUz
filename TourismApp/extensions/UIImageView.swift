//
//  UIImageView.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 23/09/23.
//

import Foundation
import Kingfisher

extension UIImageView {
    func loadImageWithURL(url: String) {
        let baseURL = "https://storage.cloud.google.com/saam/"
        if let imageURL = URL(string: baseURL + url) {
            self.kf.setImage(with: imageURL)
        }
    }
}
