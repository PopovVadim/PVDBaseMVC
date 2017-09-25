//
//  UIColorExtension.swift
//  PVDSwiftExtensions
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
public extension UIColor {
    
    /**
     * Initializer
     */
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        assert(a >= 0 && a <= 255, "Invalid alpha component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    /**
     * Initializer
     */
    convenience init(netHex:Int) {
        if netHex <= 0xFFFFFF {
            self.init(r:((netHex & 0xFF0000) >> 16), g:((netHex & 0x00FF00) >> 8), b:(netHex & 0x0000FF))
        }
        else {
            self.init(r: 255, g: 255, b: 255)
        }
    }
}
