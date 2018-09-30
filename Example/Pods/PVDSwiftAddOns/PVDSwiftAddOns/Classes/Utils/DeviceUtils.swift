//
//  DeviceUtils.swift
//  Pods-PVDSwiftExtensions_Example
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

///
open class Device {
    
    ///
    public static var id: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    public static var current: DeviceModel {
        return device(by: UIScreen.main.nativeBounds.height)
    }
    
    public static var simulating: DeviceModel {
        return device(by: UIScreen.main.bounds.height * UIScreen.main.scale)
    }
    
    private static func device(by screenHeight: CGFloat) -> DeviceModel {
        if screenHeight <= 960 {
            return .iPhone4
        }
        else if screenHeight <= 1136 {
            return .iPhone5
        }
        else if screenHeight <= 1334 {
            return .iPhone6
        }
        else if screenHeight <= 1920 {
            return .iPhonePlus
        }
        else if screenHeight <= 2436 {
            return .iPhoneX
        }
        return .iPhone6
    }
}

///
public enum DeviceModel {
    case iPhone4, iPhone5, iPhone6, iPhonePlus, iPhoneX
    
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

