//
//  CommonUtils.swift
//  Pods-PVDSwiftExtensions_Example
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

// MARK: - Arrays and iterations

public func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

// MARK: - Type casting

public func autocast<T>(_ some: Any) -> T? {
    return some as? T
}

// MARK: - Threading

/**
 *
 *
 */
public enum ThreadType {
    case main
    case background
    
    /**
     */
    private func dispatchQueue() -> DispatchQueue {
        return self == .main ? DispatchQueue.main : DispatchQueue.global(qos: .userInitiated)
    }

    /**
     */
    fileprivate func _execute(_ block: @escaping () -> Void, after seconds: Double = 0.0, completion: (() -> Void)? = nil) {
        let dispatchQueue = self.dispatchQueue()
        let executableBlock: (() -> Void) = {
            block()
            if completion != nil {
                completion!()
            }
        }
        if seconds == 0 {
            dispatchQueue.async(execute: executableBlock)
        }
        else {
            dispatchQueue.asyncAfter(deadline: .now() + seconds, execute: executableBlock)
        }
    }
}

/**
 */
public func execute (after seconds: Double = 0.0, in thread: ThreadType = .main, completion: (() -> Void)? = nil, _ block: @escaping () -> Void) {
    thread._execute(block, after: seconds, completion: completion)
}

// MARK: - Notifications

/**
 */
public func notifyAll(_ name: Notification.Name) {
    NotificationCenter.default.post(Notification(name: name))
}
