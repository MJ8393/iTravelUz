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
        view.addSubview(loaderView)
        loaderView.alpha = 0
        UIView.animate(withDuration: 0.25) { loaderView.alpha = 1 }
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
