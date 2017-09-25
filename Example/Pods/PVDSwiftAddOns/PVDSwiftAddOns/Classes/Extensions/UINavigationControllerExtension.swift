//
//  UINavigationControllerExtension.swift
//  Pods-PVDSwiftExtensions_Example
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
public extension UINavigationController {
    
    /**
     */
    func getViewController<T: UIViewController>() -> T? {
        for vc in self.viewControllers {
            debugPrint(vc.classForCoder)
            if let vc = vc as? T {
                return vc
            }
        }
        return nil
    }
}
