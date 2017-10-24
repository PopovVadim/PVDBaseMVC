//
//  Operators.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

precedencegroup BooleanPrecedence { associativity: left }
infix operator ^^ : BooleanPrecedence
/**
 Swift Logical XOR operator
 ```
 true  ^^ true   // false
 true  ^^ false  // true
 false ^^ true   // true
 false ^^ false  // false
 ```
 - parameter lhs: First value.
 - parameter rhs: Second value.
 */
func ^^(lhs: Bool, rhs: Bool) -> Bool {
    return lhs != rhs
}
