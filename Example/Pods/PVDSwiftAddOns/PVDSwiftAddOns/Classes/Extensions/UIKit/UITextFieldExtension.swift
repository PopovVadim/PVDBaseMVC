//
//  UITextField.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension UITextField {
    
    /**
     */
    func pulse (withColor color: UIColor, duration: Double = 0.5) {
        let initialColor: UIColor = self.textColor!
        UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
            self.textColor = color
        }, completion: { Void in
            UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
                self.textColor = initialColor
            }, completion: nil)
        })
    }
    
    /**
     */
    func apply(_ textDescriptor: TextDescriptor) {
        self.textColor = textDescriptor.color
        self.textAlignment = textDescriptor.alignment
        self.font = textDescriptor.font
    }
}
