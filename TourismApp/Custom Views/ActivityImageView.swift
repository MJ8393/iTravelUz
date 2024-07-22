//
//  File.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/09/23.
//

import UIKit
import SnapKit
import Kingfisher

class ActivityImageView: UIImageView {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews() {
        self.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
        startLoading()
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func loadImage(url: String?) {
        let baseURL = "https://storage.googleapis.com/saam/"
        if let imageUrl = url, let url = URL(string: baseURL + imageUrl) {
            self.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.image = value.image
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
                self.stopLoading()
            }
        }
    }
    
    func loadImageJava(url: String?) {
        if let imageUrl = url, let url = URL(string: imageUrl) {
            self.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.image = value.image
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
                self.stopLoading()
            }
        }
    }

    func setImage(image: UIImage?) {
        stopLoading()
        self.image = image
    }
}
