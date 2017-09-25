//
//  Common.swift
//  PVDSwiftExtensions
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
public extension UIApplication {
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

/**
 *
 *
 */
public extension Character {
    
    /**
     */
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}

/**
 *
 *
 */
public extension Double {
    
    ///
    var degreesToRadians: Double { return self * .pi / 180 }
    
    ///
    var radiansToDegrees: Double { return self / .pi * 180 }
}

/**
 *
 *
 */
public extension CGFloat {
    
    ///
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    
    ///
    var radiansToDegrees: CGFloat { return self / .pi * 180 }
}

/**
 *
 *
 */
public extension Dictionary {
    
    /**
     */
    mutating func join (other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

/**
 *
 *
 */
public extension UITextField {
    
    func pulse (withColor color: UIColor) {
        let initialColor: UIColor = self.textColor!
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.textColor = color
        }, completion: { Void in
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.textColor = initialColor
            }, completion: nil)
        })
    }
}

/**
 *
 *
 */
public extension Int {
    
    /**
     */
    func complementPrepending(to numberOfDigits: Int) -> String {
        
        var str = String(self)
        if str.characters.count <= numberOfDigits {
            return str
        }
        while str.characters.count < numberOfDigits {
            str = "0\(str)"
        }
        return str
    }
}
