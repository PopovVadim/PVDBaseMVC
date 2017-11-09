//
//  NumericTypesExtension.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension Int {
    
    /**
     */
    func complementPrepending(to numberOfDigits: Int) -> String {
        
        var str = String(self)
        if str.count <= numberOfDigits {
            return str
        }
        while str.count < numberOfDigits {
            str = "0\(str)"
        }
        return str
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

