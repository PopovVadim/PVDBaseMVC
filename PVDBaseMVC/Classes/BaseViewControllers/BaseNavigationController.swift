//
//  BaseNavigationController.swift
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
open class BaseNavigationController : UINavigationController, CustomPresentable {
    
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
    
    /**
     */
    open var transitionManager: TransitionManager?
    
    /**
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        transitionManager = nil
        self.transitioningDelegate = transitionManager
    }
    
    /**
     */
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return super.popToViewController(viewController, animated: animated)
    }
    
    /**
     */
    open override func popViewController(animated: Bool) -> UIViewController? {
        transitionManager?.forward = false
        return super.popViewController(animated: animated)
    }
    
    /**
     */
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        transitionManager?.forward = true
        super.pushViewController(viewController, animated: animated)
    }
}

/**
 *
 *
 */
extension BaseNavigationController : UINavigationControllerDelegate {
    
    /**
     */
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
    }
    
    /**
     */
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? transitionManager : nil
    }
}
