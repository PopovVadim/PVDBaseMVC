//
//  UIFontExtension.swift
//  PVDSwiftExtensions
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
public extension UIFont {
    
    class func systemUltralight(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.ultraLight)
    }
    
    class func systemThin(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.thin)
    }
    
    class func systemLight(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
    
    class func systemRegular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    class func systemMedium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    class func systemSemibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    class func systemBold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    class func systemHeavy(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
    }
    
    class func systemBlack(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.black)
    }
}

