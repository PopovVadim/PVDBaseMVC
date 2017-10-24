//
//  TextUtils.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation
import UIKit

/**
 */
open class TextDescriptor {
    open var color: UIColor
    open var font: UIFont
    open var alignment: NSTextAlignment
    open var numberOfLines: Int
    
    public init(_ color: UIColor, _ font: UIFont, _ alignment: NSTextAlignment, _ numberOfLines: Int = 0) {
        self.color = color
        self.font = font
        self.alignment = alignment
        self.numberOfLines = numberOfLines
    }
}

/**
 */
public protocol TextDescriptorApplicable {
    func apply (_ textDescriptor: TextDescriptor)
}
