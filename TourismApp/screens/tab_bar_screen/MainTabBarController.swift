//
//  ExploreViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 04/09/23.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var shapeLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        let nc1 = UINavigationController(rootViewController: MainViewController())
        let nc2 = UINavigationController(rootViewController: SearchVC())
        let nc3 = UINavigationController(rootViewController: MainViewController())
        let nc4 = UINavigationController(rootViewController: MainViewController())
        let nc5 = MainViewController()
        
        nc1.tabBarItem.image = UIImage(systemName: "house")
        nc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        nc4.tabBarItem.image = UIImage(systemName: "house")
        nc5.tabBarItem.image = UIImage(systemName: "house")
        nc3.tabBarItem.tag = 2
        
        tabBar.tintColor = UIColor.mainColor
        self.delegate = self
        setViewControllers([nc1, nc2, nc3, nc4, nc5], animated: true)
        setupMiddleButton()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.backgroundColor = .clear
        tabBar.unselectedItemTintColor = UIColor.init(hex: "#E3E3E3")
        UITabBar.appearance().layer.cornerRadius = 30
        UITabBar.appearance().layer.borderColor = UIColor.black.cgColor
        UITabBar.appearance().layer.borderWidth = 1
        addTabBarShadowBG()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = false
        tabBar.frame.size.height = 100
    }
    
    private func addTabBarShadowBG() {
        let tabBarCornerRadius: CGFloat = 24
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(
            roundedRect: tabBar.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: tabBarCornerRadius, height: 1.0)).cgPath
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: tabBarCornerRadius).cgPath
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.borderWidth = 1
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale

        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
           let height: CGFloat = 78
           let path = UIBezierPath()
           let centerWidth = tabBar.frame.width / 2
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
           path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                         controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
           path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                         controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabBar.frame.height))
           path.addLine(to: CGPoint(x: 0, y: tabBar.frame.height))
           path.close()
           return path.cgPath
       }
    
    let menuButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    func setupMiddleButton() {
         var menuButtonFrame = menuButton.frame
         menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
         menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
         menuButton.frame = menuButtonFrame

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
         menuButton.layer.cornerRadius = menuButtonFrame.height/2
         view.addSubview(menuButton)

        let image = UIImage(systemName: "mic.fill")?.withTintColor(.white)
        menuButton.imageView?.tintColor = .white
        menuButton.setImage(image, for: .normal)
        menuButton.contentVerticalAlignment = .fill
        menuButton.contentHorizontalAlignment = .fill
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 18, bottom: 18.5, right: 18)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        menuButton.imageView?.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
     }
    
    @objc func menuButtonAction(sender: UIButton) {
//        if sender.isUserInteractionEnabled == true {
//            sender.isUserInteractionEnabled = false
//        }
//        NotificationCenter.default.post(name: NSNotification.Name("scan"), object: nil)
//        self.tabBar.isHidden = true
//        menuButton.isHidden = true
        
//        DispatchQueue.main.async {
//            let alertVC = UINavigationController(rootViewController: QRScanerViewController())
//            alertVC.modalPresentationStyle  = .formSheet
//            alertVC.modalTransitionStyle    = .coverVertical
//            self.present(alertVC, animated: true)
//        }
//
        //self.navigationController?.pushViewController(QRScanerViewController(), animated: true)
        //present(QRScanerViewController(), animated: true)
        let vc = ChatViewController()
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tagValue = viewController.tabBarItem.tag
        if tagValue == 2 {
            return false
        }
        return true
    }
    
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 74
        return sizeThatFits
    }
}


class ActualGradientButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        
        // Define your gradient stops here
        gradient.colors = [
            UIColor.init(hex: "9B68FF").cgColor,
            UIColor.init(hex: "681AFF").cgColor,
        ]
        
        // Define your gradient start and end points here
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        // Set the corner radius
        gradient.cornerRadius = 32
        
        // Insert the gradient layer as the background
        layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }()
}

 
class CustomTabBar: UITabBar {
    private let customHeight: CGFloat = 64 // Set your desired tab bar height

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}
