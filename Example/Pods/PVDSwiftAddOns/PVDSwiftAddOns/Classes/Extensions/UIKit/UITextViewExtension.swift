//
//  UITextViewExtension.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 2/2/18.
//

import Foundation

/**
 *
 *
 */
public extension UITextView {
    
    /**
     */
    public func apply(_ textDescriptor: TextDescriptor) {
        self.textColor = textDescriptor.color
        self.textAlignment = textDescriptor.alignment
        self.font = textDescriptor.font
    }
}
