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
        
        if let image = uploadImage.resizedTo1MB() {
            uploadImageFor(image: image, username: "x")
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

extension UIImage {
    func resizedTo1MB() -> UIImage? {
        let megaByte = 1490000.0 // 1 MB = 1,000,000 bytes

        var resizingImage = self
        var imageSizeBytes = Double(self.jpegData(compressionQuality: 1.0)?.count ?? 0)

        while imageSizeBytes > megaByte {

            guard let resizedImage = resizingImage.resized(withPercentage: 0.75),
                  let resizedImageData = resizedImage.jpegData(compressionQuality: 1.0) else {
                break
            }

            resizingImage = resizedImage
            imageSizeBytes = Double(resizedImageData.count)
        }

        return resizingImage
    }

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension ImageLoaderViewController {
    private func uploadImageFor(image: UIImage, username: String) {
        let url = URL(string: "http://35.215.137.189:8000/")!
        var request = URLRequest(url: url)
        let boundary = UUID().uuidString
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
        request.httpMethod = "POST"
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        let params = ["full_name": "\(username)"]
        let dataBody = createDataBody(withParameters: params, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                let jsonResponse = data?.prettyPrintedJSONString
                    print("JSON String: \(jsonResponse)")

                if let jsonData = data {
                    do {
                        // Parse JSON data into YourModel
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(ImageRecognitionModel.self, from: jsonData)
                        

                        if httpResponse.statusCode == 401 {
                            // Handle 401 status code
                            DispatchQueue.main.async {
                                // Show alert for 401
                                self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                    self.dismiss(animated: true)
                                }
                            }
                        } else if httpResponse.statusCode == 200 {
                            // Handle 200 status code
                            DispatchQueue.main.async {
                                if decodedData.predictions?.count != 0 && decodedData.objects?.count != 0 {
                                    if let prediction = decodedData.predictions {
                                        
                                        let rate = prediction[0].confidence
                                        if rate >= 0.60 {
                                            if let objects = decodedData.objects {
                                                let vc = ExploreViewController()
                                                let newDes = objects[0]
                                                vc.isImageRecognition = true
                                                let destination = MainDestination(id: newDes._id, name: newDes.name, location: newDes.location, city_name: newDes.city_name, description: newDes.description, recommendationLevel: newDes.recommendationLevel, gallery: newDes.gallery, comments: newDes.comments, tts: newDes.tts)
                                                vc.destination = destination
                                                vc.isCity = false
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            } else {
                                                DispatchQueue.main.async {
                                                    self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                                        self.dismiss(animated: true)
                                                    }
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                                    self.dismiss(animated: true)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                            self.dismiss(animated: true)
                                        }
                                    }
                                }
                            }
                        } else {
                            // Handle other status codes
                            DispatchQueue.main.async {
                                self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                    self.dismiss(animated: true)
                                }
                            }
                        }

                    } catch {
                        // Handle JSON decoding error
                        print("Error decoding JSON: \(error)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "Failure", message: "We could not identify the historical destination in the photo you took.") {
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }

        task.resume()
    } //END OF uploadImage
    
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
          for (key, value) in parameters {
              body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
             body.append("\(value as! String + lineBreak)".data(using: .utf8)!)
          }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)".data(using: .utf8)!)
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)".data(using: .utf8)!)
             body.append(photo.data)
             body.append(lineBreak.data(using: .utf8)!)
          }
       }
       body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
       return body
    }
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}

struct ImageRecognitionModel: Codable {
    let predictions: [Predictions]?
    let objects: [ImageDestination]?
}

struct Predictions: Codable {
    let display_name: String?
    let ids: String?
    let confidence: Double
}

struct ImageDestination: Codable {
    let _id: String
    let name: DestionationName?
    let location: MainLocation?
    let city_name: CityName?
    let description: DescriptionString?
    let recommendationLevel: MainRecomentationLevel?
    let gallery: [Gallery]?
    let comments: [MainComment]?
    let tts: TTSModel?
}
