//
//  FuckYouViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 29/11/23.
//

import UIKit

extension UIViewController {
    func presentXXXXOnMainThread(offset: CGFloat){
        // trowing things to the main thread
        DispatchQueue.main.async {
            
            let alertVC = AlertVC()
            alertVC.offset = offset
//                        let alertVC = UINavigationController(rootViewController: QRScanerViewController())

            alertVC.modalPresentationStyle = .overFullScreen
//            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: false)
        }
    }
}

class AlertVC: UIViewController {
    
    let padding: CGFloat = 20
    
    var offset: CGFloat = 50
    
    let menuButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    
    init(){
        super.init(nibName: nil, bundle: nil)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let blurEffectView = UIVisualEffectView(effect:  UIBlurEffect(style: UIBlurEffect.Style.regular))

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        blurEffectView.alpha = 0.0
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupMiddleButton()
        setupTranslateButton()
        setupCameraButton()
        setupChatButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            // Your animation code here
            self.translateButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(-self.offset)
            }
            
            let image = UIImage(systemName: "mic.fill")?.withTintColor(.white)
            self.chatButton.imageView?.tintColor = .white
            self.chatButton.setImage(image, for: .normal)
            
            self.cameraButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(-self.offset)
            }
            
            self.chatButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.menuButton.snp.top).offset(-25)
            }

            self.blurEffectView.alpha = (self.blurEffectView.alpha == 0.0) ? 1.0 : 0.0

            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }


    @objc func dismissVC(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            // Your animation code here for disappearing
            self.translateButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.cameraButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.chatButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.menuButton.snp.top).offset(64)
            }
            
            let image = UIImage(systemName: "square.grid.2x2")?.withTintColor(.white)
            self.chatButton.imageView?.tintColor = .white
            self.chatButton.setImage(image, for: .normal)

            self.blurEffectView.alpha = 0.0 // Set the final alpha for disappearing

            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            // Code to execute after the animation completes
            if finished {
                self.dismiss(animated: false)
            }
        })

        
    }
    
    func setupMiddleButton() {
        view.addSubview(menuButton)
        print("xxx", -self.offset)
        menuButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-self.offset)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
         menuButton.layer.cornerRadius = 32

        let image = UIImage(systemName: "xmark")?.withTintColor(.white)
        menuButton.imageView?.tintColor = .white
        menuButton.setImage(image, for: .normal)
        menuButton.contentVerticalAlignment = .fill
        menuButton.contentHorizontalAlignment = .fill
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 18, bottom: 18.5, right: 18)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuButton.imageView?.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
     }
    
    @objc func menuButtonTapped() {
        dismissVC()
    }
    
    
    let translateButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    func setupTranslateButton() {
        view.addSubview(translateButton)
        translateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(64)
            make.right.equalTo(menuButton.snp.left).offset(-25)
            make.width.height.equalTo(64)
        }

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
        translateButton.layer.cornerRadius = 32

        let image = UIImage(systemName: "globe")?.withTintColor(.white)
        translateButton.imageView?.tintColor = .white
        translateButton.setImage(image, for: .normal)
        translateButton.contentVerticalAlignment = .fill
        translateButton.contentHorizontalAlignment = .fill
        translateButton.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 18, bottom: 18.5, right: 18)
        translateButton.addTarget(self, action: #selector(translateButtonAction), for: .touchUpInside)
        translateButton.imageView?.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
     }
    
    let cameraButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    func setupCameraButton() {
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
            make.left.equalTo(menuButton.snp.right).offset(25)
            make.width.height.equalTo(64)
        }

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
        cameraButton.layer.cornerRadius = 32

        let image = UIImage(systemName: "camera")?.withTintColor(.white)
        cameraButton.imageView?.tintColor = .white
        cameraButton.setImage(image, for: .normal)
        cameraButton.contentVerticalAlignment = .fill
        cameraButton.contentHorizontalAlignment = .fill
        cameraButton.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 18, bottom: 18.5, right: 18)
        cameraButton.imageView?.contentMode = .scaleAspectFit
        cameraButton.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        view.layoutIfNeeded()
     }
    
    let chatButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    func setupChatButton() {
        view.addSubview(chatButton)
        chatButton.snp.makeConstraints { make in
            make.bottom.equalTo(menuButton.snp.top).offset(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
        chatButton.layer.cornerRadius = 32

        let image = UIImage(systemName: "square.grid.2x2")?.withTintColor(.white)
        chatButton.imageView?.tintColor = .white
        chatButton.setImage(image, for: .normal)
        chatButton.contentVerticalAlignment = .fill
        chatButton.contentHorizontalAlignment = .fill
        chatButton.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 18, bottom: 18.5, right: 18)
        chatButton.addTarget(self, action: #selector(chatButtonAction), for: .touchUpInside)
        chatButton.imageView?.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
     }
    
    @objc func translateButtonAction() {
        // Dismiss the current view controller
        weak var pvc = self.presentingViewController
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            // Your animation code here for disappearing
            self.translateButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.cameraButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.chatButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.menuButton.snp.top).offset(64)
            }
            

            self.blurEffectView.alpha = 0.0 // Set the final alpha for disappearing

            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            // Code to execute after the animation completes
            if finished {
                self.dismiss(animated: false, completion: {
                    let registerVC = TranslatorViewController()
                    
                    // Set up the navigation controller with the new view controller as the root
                    let navigationController = UINavigationController(rootViewController: registerVC)
                    navigationController.modalPresentationStyle = .fullScreen

                    // Create a back button for the new view controller
                    let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")!, style: .plain, target: self, action: #selector(self.dismissRegisterViewController))
                    backButton.tintColor = .label

                    // Set the back button for the new view controller
                    registerVC.navigationItem.leftBarButtonItem = backButton
                    
                    // Present the new navigation controller
                    pvc!.present(navigationController, animated: true, completion: nil)
                })
            }
        })
    }
    
    @objc func chatButtonAction() {
        // Dismiss the current view controller
        weak var pvc = self.presentingViewController
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            // Your animation code here for disappearing
            self.translateButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.cameraButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.chatButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.menuButton.snp.top).offset(64)
            }

            self.blurEffectView.alpha = 0.0 // Set the final alpha for disappearing

            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            // Code to execute after the animation completes
            if finished {
                self.dismiss(animated: false, completion: {
                    let registerVC = ChatViewController()
                    
                    // Set up the navigation controller with the new view controller as the root
                    let navigationController = UINavigationController(rootViewController: registerVC)
                    navigationController.modalPresentationStyle = .fullScreen

                    // Create a back button for the new view controller
                    let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")!, style: .plain, target: self, action: #selector(self.dismissRegisterViewController))
                    backButton.tintColor = .label

                    // Set the back button for the new view controller
                    registerVC.navigationItem.leftBarButtonItem = backButton
                    
                    // Present the new navigation controller
                    pvc!.present(navigationController, animated: true, completion: nil)
                })
            }
        })
    }
    
    @objc func dismissRegisterViewController() {
        self.dismiss(animated: true)
    }
    
    
    @objc func cameraButtonAction() {
        // Dismiss the current view controller
        weak var pvc = self.presentingViewController
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            // Your animation code here for disappearing
            self.translateButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.cameraButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(64)
            }

            self.chatButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.menuButton.snp.top).offset(64)
            }

            self.blurEffectView.alpha = 0.0 // Set the final alpha for disappearing

            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            if finished {
                self.dismiss(animated: false, completion: {
                    let vc = UINavigationController(rootViewController: MyCameraViewController())
                    vc.modalPresentationStyle = .fullScreen
                    pvc!.present(vc, animated: true, completion: nil)
                })
            }
        })
    }
}
