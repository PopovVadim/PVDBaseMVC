//
//  CollectionExtensions.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension Dictionary {
    
    /**
     */
    mutating func join (other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

/**
 *
 *
 */
public extension Array where Element: Equatable {
    
    /**
     * Removes first collection element that is equal to the given `object`
     */
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
