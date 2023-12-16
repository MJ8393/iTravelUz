//
//  CameraViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 29/11/23.
//

import CameraManager

class MyCameraViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let cameraManager = CameraManager()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shutter"), for: .normal)
        button.addTarget(self, action: #selector(shutterTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var swapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.addTarget(self, action: #selector(swapTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(xTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        button.addTarget(self, action: #selector(flashTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var labraryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(libraryTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()
    
    lazy var libraryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        button.addTarget(self, action: #selector(libraryTapped), for: .touchUpInside)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        initViews()
        navigationController?.navigationBar.isHidden = true
        
        cameraManager.addPreviewLayerToView(self.subView)
        cameraManager.cameraOutputQuality = .high
        cameraManager.cameraOutputMode = .stillImage
        cameraManager.shouldEnableExposure = false
        cameraManager.animateShutter = true
        cameraManager.animateCameraDeviceChange = true
        
        fetchLastPhoto()
        
        cameraManager.flashMode = .off
        flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(72)
        }
        
        view.addSubview(swapButton)
        swapButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalTo(cameraButton)
            make.height.width.equalTo(50)
        }
        
        view.addSubview(libraryButton)
        libraryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(cameraButton)
            make.height.width.equalTo(50)
        }
        
        view.addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(50)
            make.height.width.equalTo(50)
        }
        
        view.addSubview(flashButton)
        flashButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(50)
            make.height.width.equalTo(50)
        }
        
        view.addSubview(labraryImageView)
        labraryImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(cameraButton)
            make.height.width.equalTo(40)
        }
    }
    
    func fetchLastPhoto() {
        let photoLibraryManager = PhotoLibraryManager()

        photoLibraryManager.fetchLastPhoto { (image) in
            if let lastPhoto = image {
                self.labraryImageView.image = lastPhoto
                self.labraryImageView.isHidden = false
                self.libraryButton.isHidden = true
            } else {
                print("error")
                self.labraryImageView.isHidden = true
                self.libraryButton.isHidden = false
            }
        }
    }
    
    
    func captureImage() {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    // error handling
                break
                case .success(let content):
                let myImage = content.asImage
                let vc = ImageLoaderViewController()
                vc.setImage(image: myImage)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @objc func shutterTapped() {
        Vibration.light.vibrate()
        captureImage()
    }
    
    @objc func swapTapped() {
        Vibration.light.vibrate()
        if cameraManager.cameraDevice == .front {
            cameraManager.cameraDevice = .back
        } else {
            cameraManager.cameraDevice = .front
        }
    }
    
    @objc func xTapped() {
        Vibration.light.vibrate()
        self.dismiss(animated: true)
    }
    
    @objc func flashTapped() {
        Vibration.light.vibrate()
        if cameraManager.flashMode == .off  {
            cameraManager.flashMode = .on
            flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        } else {
            cameraManager.flashMode = .off
            flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        }
    }
    
    @objc func libraryTapped() {
        Vibration.light.vibrate()
        ImagePickerManager().pickImage(self){ image  in
            //here is the image
            let vc = ImageLoaderViewController()
            vc.setImage(image: image)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
