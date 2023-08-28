//
//  LoaderViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 28/08/23.
//

import UIKit

fileprivate var loaderView: LoaderView!

extension UIViewController {
    
    func showLoadingView(){
        loaderView = LoaderView(frame: view.bounds)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            window.addSubview(loaderView)
            loaderView.alpha = 0
            UIView.animate(withDuration: 0.25) { loaderView.alpha = 1 }
        }
    }
    
    func dissmissLoadingView(){
        guard let loaderView = loaderView else {
            return
        }
        loaderView.removeFromSuperview()
        UIView.animate(withDuration: 0.25, animations: {
            loaderView.alpha = 0
        }) { _ in
            
        }
    }
}
