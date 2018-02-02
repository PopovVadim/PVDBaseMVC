//
//  UIButtonExtension.swift
//  PVDSwiftAddOns
//
//  Created by Вадим Попов on 2/2/18.
//

import Foundation

/**
 *
 *
 */
public extension UIButton {
    
    /**
     */
    public func setTitleColor(_ normalColor: UIColor, _ highlightedColor: UIColor) {
        self.setTitleColor(normalColor, for: .normal)
        self.setTitleColor(highlightedColor, for: .highlighted)
    }
}
