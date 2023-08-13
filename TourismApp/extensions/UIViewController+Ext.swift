//
//  UIViewController+Ext.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 12/08/23.
//

import UIKit

extension UIViewController {
    
    func getBottomMargin() -> CGFloat{
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom{
                return bottomPadding
            }
        }
        
        return 0
    }
    
}
