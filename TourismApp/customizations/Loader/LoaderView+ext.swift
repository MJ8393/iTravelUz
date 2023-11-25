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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
             loaderView.alpha = 1
         }, completion: nil)
    }
    
    func dissmissLoadingView(){
        guard let loaderView = loaderView else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            DispatchQueue.main.async {
                loaderView.alpha = 0
            }
          }) { _ in
              loaderView.removeFromSuperview()
          }
    }
}
