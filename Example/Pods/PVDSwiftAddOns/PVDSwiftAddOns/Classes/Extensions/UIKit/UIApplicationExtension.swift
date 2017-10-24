//
//  UIApplicationExtension.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension UIApplication {
    
    /**
     */
    class func topVC(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topVC(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topVC(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topVC(controller: presented)
        }
        return controller
    }
}
