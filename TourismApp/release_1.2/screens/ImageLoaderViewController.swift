//
//  ImageLoaderViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 01/12/23.
//

import UIKit
import Alamofire

class ImageLoaderViewController: UIViewController {
    
    var squareWidth: Double = 0
    var topLeftPosX: Double = 0
    var topLeftPosY: Double = 0
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topView: HeroHeaderView = {
        let view = HeroHeaderView()
        return view
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var exampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scanFor")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var scanLabel: UILabel = {
        let label = UILabel()
        label.text = "We try to identify the historical building in the photo you took"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var analysingLabel: UILabel = {
        let label = UILabel()
        label.text = "Analyzing your photo"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    var uploadImage = UIImage()
    
    var activityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        squareWidth = view.frame.width * 0.6
        topLeftPosX = view.frame.width * 0.2
        topLeftPosY = view.frame.midY - (squareWidth / 2)
        
        view.backgroundColor = .black
        
        createScanningFrame()
        createScanningIndicator()
        initViews()
        activityIndicator.startAnimating()
        
        API.shared.uploadImage(uploadImage, filename: "image") { str in
            print("TTTTT", str)
        }
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(UIScreen.main.bounds.height / 4)
        }
        
        view.addSubview(exampleImageView)
        exampleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(topLeftPosX + 1)
            make.top.equalToSuperview().offset(topLeftPosY + 1)
            make.height.width.equalTo(squareWidth - 2)
        }
        
        view.addSubview(mainView)
        mainView.frame = view.bounds
        
        view.addSubview(scanLabel)
        scanLabel.snp.makeConstraints { make in
            make.top.equalTo(exampleImageView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-getBottomMargin() - 20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(30)
        }
        
        view.addSubview(analysingLabel)
        analysingLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(activityIndicator.snp.top).offset(-12.5)
        }
        
     
    }
    
    func setImage(image: UIImage?) {
        if let image = image {
            uploadImage = image
        }
        exampleImageView.image = image
    }
}


extension ImageLoaderViewController {
    func createScanningIndicator() {
        
        let height: CGFloat = 20
        let opacity: Float = 0.4
        let topColor = UIColor.white.withAlphaComponent(0)
        let bottomColor = UIColor.white

        let layer = CAGradientLayer()
        layer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.opacity = opacity
        
        let squareWidth = view.frame.width * 0.6
        let xOffset = view.frame.width * 0.2
        let yOffset = view.frame.midY - (squareWidth / 2)
        layer.frame = CGRect(x: xOffset, y: yOffset, width: squareWidth, height: height)
        
        self.mainView.layer.insertSublayer(layer, at: 0)

        let initialYPosition = layer.position.y
        let finalYPosition = initialYPosition + squareWidth - height
        let duration: CFTimeInterval = 2

        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = initialYPosition as NSNumber
        animation.toValue = finalYPosition as NSNumber
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: nil)
    }
    
    func createScanningFrame() {
                
        let lineLength: CGFloat = 40
        let btmLeftPosY = view.frame.midY + (squareWidth / 2)
        let btmRightPosX = view.frame.midX + (squareWidth / 2)
        let topRightPosX = view.frame.width * 0.8
        
        let path = UIBezierPath()
        
        //top left
        path.move(to: CGPoint(x: topLeftPosX, y: topLeftPosY + lineLength))
        path.addLine(to: CGPoint(x: topLeftPosX, y: topLeftPosY))
        path.addLine(to: CGPoint(x: topLeftPosX + lineLength, y: topLeftPosY))

        //bottom left
        path.move(to: CGPoint(x: topLeftPosX, y: btmLeftPosY - lineLength))
        path.addLine(to: CGPoint(x: topLeftPosX, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: topLeftPosX + lineLength, y: btmLeftPosY))

        //bottom right
        path.move(to: CGPoint(x: btmRightPosX - lineLength, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: btmRightPosX, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: btmRightPosX, y: btmLeftPosY - lineLength))

        //top right
        path.move(to: CGPoint(x: topRightPosX, y: topLeftPosY + lineLength))
        path.addLine(to: CGPoint(x: topRightPosX, y: topLeftPosY))
        path.addLine(to: CGPoint(x: topRightPosX - lineLength, y: topLeftPosY))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.fillColor = UIColor.clear.cgColor
        
        self.mainView.layer.insertSublayer(shape, at: 0)
    }
}



import UIKit

class HeroHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "scanFor")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        addGradient()  // Move the call to addGradient here
    }
    
    private func applyConstraints() {
        // Add your constraints here if needed
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}

extension API {
    func uploadDocument(_ file: Data, filename : String, handler : @escaping (String) -> Void) {

           AF.upload(
               multipartFormData: { multipartFormData in
                   multipartFormData.append(file, withName: "upload_data" , fileName: filename, mimeType: "application/pdf")
           },
               to: "http://35.215.137.189:8000", method: .post , headers: nil)
               .response { response in
                   if let data = response.data{
                       //handle the response however you like
                   }

           }
     }
    
    func uploadImage(_ image: UIImage, filename: String, handler: @escaping (String) -> Void) {
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            // Handle error if conversion fails
            return
        }

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", mimeType: "image/jpeg")
            },
            to: "http://35.215.137.189:8000", method: .get, headers: nil)
            .response { response in
                if let data = response.data {
                    // Handle the response however you like
                    handler(String(data: data, encoding: .utf8) ?? "")
                }
        }
    }

}
