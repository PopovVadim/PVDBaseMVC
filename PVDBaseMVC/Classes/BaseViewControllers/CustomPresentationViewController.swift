//
//  CustomPresentationViewController.swift
//  Pods-PVDStarterPackSwiftUI_Tests
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation
import UIKit

/**
 *
 *
 */
public protocol CustomPresentable {
    var interactive: Bool {get set}
    var transitionManager: TransitionManager? {get set}
}

/**
 *
 *
 */
open class CustomPresentationViewController : BaseViewController, CustomPresentable {
    
    ///
    fileprivate var _interactive: Bool = false
    open var interactive:Bool {
        get {
            return _interactive
        }
        set {
            _interactive = newValue
            transitionManager?.interactive = newValue
        }
    }
    
    ///
    private var _transitionManager: TransitionManager?
    open var transitionManager: TransitionManager? {
        get {
            return _transitionManager
        }
        set {
            _transitionManager = newValue
            self.transitioningDelegate = newValue
        }
    }
    
    /**
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        transitionManager = nil
        self.transitioningDelegate = transitionManager
        self.modalPresentationStyle = .custom
    }
}
