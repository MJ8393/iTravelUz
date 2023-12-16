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
        let nc4 = UINavigationController(rootViewController: SearchVC())
        let nc3 = UINavigationController(rootViewController: FavoritesViewController())
        let nc2 = UINavigationController(rootViewController: PagerController())
        let nc5 = UINavigationController(rootViewController: ProfileViewController())

        
        nc1.title = "home".translate()
        nc2.title = "search".translate()
        nc4.title = "Exprole"
        nc5.title = "profile".translate()

                
        nc1.tabBarItem.image = UIImage(systemName: "house")
        nc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        nc4.tabBarItem.image = UIImage(systemName: "globe")
        nc5.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        nc3.tabBarItem.tag = 2
        
        tabBar.tintColor = UIColor.mainColor
        self.delegate = self
        setViewControllers([nc1, nc2, nc3, nc4, nc5], animated: true)
        setupMiddleButton()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ChangeTabBar"), object: nil, queue: nil) { _ in
            nc1.title = "home".translate()
            nc2.title = "search".translate()
            nc4.title = "translator".translate()
            nc5.title = "profile".translate()
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.backgroundColor = .clear
        tabBar.unselectedItemTintColor = UIColor(named: "tabbarbutton")
        UITabBar.appearance().layer.cornerRadius = 30
        UITabBar.appearance().layer.borderColor = UIColor.black.cgColor
        UITabBar.appearance().layer.borderWidth = 1
        addTabBarShadowBG()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = false
    }

    
    private func addTabBarShadowBG() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor(named: "tabbar")?.cgColor
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        shapeLayer.lineWidth = 1
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
           let height: CGFloat = 74
           let path = UIBezierPath()
           let centerWidth = tabBar.frame.width / 2
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: (centerWidth - height), y: 0))
           path.addCurve(to: CGPoint(x: centerWidth, y: height / 2),
                         controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height / 2))
           path.addCurve(to: CGPoint(x: (centerWidth + height), y: 0),
                         controlPoint1: CGPoint(x: centerWidth + 35, y: height / 2), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
           path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabBar.frame.height))
           path.addLine(to: CGPoint(x: 0, y: tabBar.frame.height))
           path.close()
           return path.cgPath
       }
    
    let menuButton = ActualGradientButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    func setupMiddleButton() {
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top).offset(-32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }

         //menuButton.backgroundColor = UIColor.init(hex: "6980FD")
         menuButton.layer.cornerRadius = 32

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
        Vibration.medium.vibrate()
        self.presentXXXXOnMainThread()
    }
    
    @objc func dismissRegisterViewController() {
        self.dismiss(animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tagValue = viewController.tabBarItem.tag
        if tagValue == 2 {
            return false
        }
        return true
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


extension UITabBarController{

    func getHeight()->CGFloat{
        return self.tabBar.frame.size.height
    }

    func getWidth()->CGFloat{
         return self.tabBar.frame.size.width
    }
}
