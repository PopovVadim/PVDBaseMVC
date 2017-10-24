//
//  UILabel.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation
import UIKit

/**
 *
 *
 */
public extension UILabel {
    
    /**
     */
    func blinkText(withColor color: UIColor, duration: Double = 0.5) {
        let initialColor = self.textColor
        UIView.transition(with: self, duration: duration/2, options: .transitionCrossDissolve, animations: {
            self.textColor = color
        }, completion: { _ in
            UIView.transition(with: self, duration: duration/2, options: .transitionCrossDissolve, animations: {
                self.textColor = initialColor
            }, completion: nil)
        })
    }
    
    /**
     */
    func apply (_ textDescriptor: TextDescriptor) {
        self.textColor = textDescriptor.color
        self.textAlignment = textDescriptor.alignment
        self.font = textDescriptor.font
        self.numberOfLines = textDescriptor.numberOfLines
    }
}
