//
//  TestVoewControllerViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 23/09/23.
//

import UIKit
import Kingfisher

class TestVoewControllerViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Registan")!
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    private func initViews() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
        if let url = URL(string: "https://storage.googleapis.com/saam/destination_64fb297ee2bfdf8afb8a1788_ARK.JPG") {
            imageView.kf.setImage(with: url) { result in
                print(url)
                switch result {
                case .success(let imageResult):
                    // Handle the success case here.
                    // `imageResult.image` contains the loaded image.
                    print("Image loaded successfully")
                case .failure(let error):
                    // Handle the failure case here.
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }

    }

}
