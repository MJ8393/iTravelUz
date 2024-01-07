//
//  UIViewController+Ext.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getBottomMargin() -> CGFloat{
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom{
                return bottomPadding
            }
        }
        
        return 0
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            completion?()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setNewRootViewController() {
          let newRootViewController = MainTabBarController()
          if let sceneDelegate = SceneDelegate.shared {
              sceneDelegate.window?.rootViewController = newRootViewController
          }
      }
    
    func goLoginPage() {
        let newRootViewController = LoginViewController()
        if let sceneDelegate = SceneDelegate.shared {
            sceneDelegate.window?.rootViewController = newRootViewController
        }
    }
}

class Helper {
    static func getTopPadding() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.windows.first {
                let topSafeAreaHeight = window.safeAreaInsets.top
                return topSafeAreaHeight
            }
        } else {
            return 0.0
        }
        return 0.0
    }
    
    static func getBottomPadding() -> CGFloat {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.windows.first {
                let bottomSafeAreaHeight = window.safeAreaInsets.bottom
                return bottomSafeAreaHeight
            }
        } else {
            return 0.0
        }
        return 0.0
    }
    
    static func getDefaultLocation() -> (lat: Double, lon: Double){
        return (41.2995, 69.2401)
    }
}
