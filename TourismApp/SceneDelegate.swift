//
//  SceneDelegate.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 31/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    static var shared: SceneDelegate?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        SceneDelegate.shared = self
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        setMode()
        SwiftGoogleTranslate.shared.start(with: "AIzaSyC485-l38_P2OP1xZA710_qbo2j3jQMtRs")
        
        let vc = MainTabBarController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        //        // MARK: Login
        //        if let token = UD.token, token.replacingOccurrences(of: " ", with: "") != "" {
        //            let vc = MainTabBarController()
        //            window?.rootViewController = vc
        //        } else {
        //            let vc = LoginViewController()
        //            window?.rootViewController = vc
        //        }
        //
        ////        let vc = MainTabBarController()
        ////        window?.rootViewController = vc
        //        window?.makeKeyAndVisible()
        //        API.shared.getFavorites { result in
        //            switch result {
        //            case .success(_):
        //                print("success get favorite")
        //            case .failure(_):
        //                print("failure get favorites")
        //            }
        //        }
        //    }
        
        func setMode() {
            let viewMode = UD.mode ?? ""
            if !viewMode.isEmpty {
                if viewMode == "light" {
                    window?.overrideUserInterfaceStyle = .light
                } else if viewMode == "dark" {
                    window?.overrideUserInterfaceStyle = .dark
                } else if viewMode == "system" {
                    let mode = Functions.getDeviceMode()
                    if mode == .light {
                        window?.overrideUserInterfaceStyle = .light
                    } else if mode == .dark {
                        window?.overrideUserInterfaceStyle = .dark
                    } else {
                        window?.overrideUserInterfaceStyle = .light
                    }
                }
            } else {
                let mode = Functions.getDeviceMode()
                if mode == .light {
                    window?.overrideUserInterfaceStyle = .light
                } else if mode == .dark {
                    window?.overrideUserInterfaceStyle = .dark
                } else {
                    window?.overrideUserInterfaceStyle = .light
                }
                UD.mode = "system"
            }
        }
        
        
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
            
            // Active
//            window?.rootViewController?.hideBlurFront()
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
            
            // View in foreground
//            window?.rootViewController?.showBlurFront()
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
        
        
        func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
            if #available(iOS 13.0, *) {
                if previousTraitCollection.hasDifferentColorAppearance(comparedTo: windowScene.traitCollection) {
                    let mode = UD.mode
                    if mode == "system" {
                        if windowScene.traitCollection.userInterfaceStyle == .dark {
                            window?.overrideUserInterfaceStyle = .dark
                        } else {
                            window?.overrideUserInterfaceStyle = .light
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
//    
//    extension UIViewController {
//        func showBlurFront() {
//            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            blurEffectView.accessibilityIdentifier = "blur_front"
//            view.addSubview(blurEffectView)
//            
//            blurEffectView.alpha = 0
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
//                blurEffectView.alpha = 1
//            }, completion: nil)
//            
//            blurEffectView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
//        
//        func hideBlurFront() {
//            if let blurEffectView = view.subviews.first(where: { $0.accessibilityIdentifier == "blur_front" }) as? UIVisualEffectView {
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                    blurEffectView.alpha = 0
//                }, completion: { _ in
//                    blurEffectView.removeFromSuperview()
//                })
//            }
//        }
//    }
    
}
