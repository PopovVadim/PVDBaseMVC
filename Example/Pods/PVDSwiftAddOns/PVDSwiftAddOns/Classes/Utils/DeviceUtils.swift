//
//  DeviceUtils.swift
//  Pods-PVDSwiftExtensions_Example
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
public class Device {
    
    ///
    static var id: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    ///
    open static var current: DeviceModel {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        if h <= 480 {
            return .iPhone4
        }
        else if w <= 320 {
            return .iPhone5
        }
        else if w <= 375 {
            return .iPhone6
        }
        else if w <= 414 {
            return .iPhonePlus
        }
        return .iPhone6
    }
}

/**
 *
 *
 */
public enum DeviceModel {
    case iPhone4, iPhone5, iPhone6, iPhonePlus
    
    /**
     */
    public func fontScale() -> CGFloat {
        switch self {
        case .iPhone4:
            return 0.7
        case .iPhone5:
            return 0.8
        default:
            return 1.0
        }
    }
}
