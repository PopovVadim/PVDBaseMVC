//
//  CGFloat.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension CGFloat {
    
    ///
    var degreesToRadians: CGFloat { return CGFloat(Double(self).degreesToRadians) }
    
    ///
    var radiansToDegrees: CGFloat { return CGFloat(Double(self).radiansToDegrees) }
}
