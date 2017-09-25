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
public class CustomPresentationViewController : BaseViewController {
    
    ///
    fileprivate var _interactive: Bool = false
    var interactive:Bool {
        get {
            return _interactive
        }
        set {
            _interactive = newValue
            transitionManager?.interactive = newValue
        }
    }
    
    ///
    private var _transitionType: TransitionTypes = .defaultType
    var transitionType: TransitionTypes {
        get {
            return _transitionType
        }
        set {
            _transitionType = newValue
            transitionManager = newValue.transitionManager()
            self.transitioningDelegate = transitionManager
        }
    }
    
    /**
     */
    var transitionManager: TransitionManager?
    
    /**
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        transitionManager = transitionType.transitionManager()
        self.transitioningDelegate = transitionManager
        self.modalPresentationStyle = .custom
    }
}
