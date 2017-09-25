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
public class BaseNavigationController : UINavigationController {
    
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
        }
    }
    
    /**
     */
    var transitionManager: TransitionManager?
    
    /**
     */
    var statusBarHeight: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /**
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        transitionManager = transitionType.transitionManager()
        self.delegate = self
        self.transitioningDelegate = transitionManager
        
        adjustFrame()
    }
    
    /**
     */
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        adjustFrame()
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
        adjustFrame()
        super.pushViewController(viewController, animated: animated)
    }
    
    /**
     */
    func adjustFrame() {
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

/**
 *
 *
 */
extension BaseNavigationController : UINavigationControllerDelegate {
    
    /**
     */
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
    }
    
    /**
     */
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? transitionManager : nil
    }
}
