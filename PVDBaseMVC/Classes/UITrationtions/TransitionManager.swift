//
//  TransitionManager.swift
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
public enum TransitionTypes: String {
    
    case defaultType = "default"
    case crossDissolve = "cross_dissolve"
    case sideBySide = "sideBySide"
    
    func transitionManager() -> TransitionManager? {
        switch self {
        case .crossDissolve:
            return CrossDissolveTransitionManager()
        case .sideBySide:
            return SideBySideTransitionManager()
        default:
            return nil
        }
    }
}

/**
 *
 *
 */
open class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    open var forward = true
    open var interactive = false
    
    private static var _instance: TransitionManager!
    open static var shared: TransitionManager {
        get {
            if _instance == nil {
                _instance = TransitionManager()
            }
            return _instance
        }
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.forward = true
        return self
    }
    
    // what UIViewControllerAnimatedTransitioning object to use for presenting
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?  {
        self.forward = false
        return self
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    // MARK: UIViewControllerAnimatedTransitioning methods
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    // perform the animation(s) to show the transition from one screen to another
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Delegate to child classes
    }
}

/**
 *
 *
 */
open class CrossDissolveTransitionManager : TransitionManager {
    
    // perform the animation(s) to show the transition from one screen to another
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to the container view that we should perform the transition in
        let container = transitionContext.containerView
        
        // get references to our 'from' and 'to' view controllers
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        // get references to the root views of both controllers
        let fromView = fromViewController.view!
        let toView = toViewController.view!
        
        toView.frame = fromView.frame
        toView.center = fromView.center
        
        // set the start location of toView depending if we're presenting or not
        toView.alpha = forward ? 0 : 1
        // add the both views to our view controller
        if forward {
            container.addSubview(fromView)
            container.addSubview(toView)
        }
        else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        
        // get the duration of the animation
        let duration = self.transitionDuration(using: transitionContext)
        
        let options = interactive ? UIViewAnimationOptions.curveLinear : UIViewAnimationOptions.curveEaseOut
        
        // perform the animation
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            if self.forward {
                toView.alpha = 1
            }
            else {
                fromView.alpha = 0
            }
        }, completion: { finished in
            // tell our transitionContext object that we've finished animating
            if(transitionContext.transitionWasCancelled){
                transitionContext.completeTransition(false)
            }
            else {
                transitionContext.completeTransition(true)
            }
        })
    }
}

/**
 *
 *
 */
open class SideBySideTransitionManager : TransitionManager {
    
    // perform the animation(s) to show the transition from one screen to another
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to the container view that we should perform the transition in
        let container = transitionContext.containerView
        
        container.backgroundColor = UIColor.black
        
        // get references to our 'from' and 'to' view controllers
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        
        // get references to the root views of both controllers
        let fromView = fromViewController.view
        let toView = toViewController.view
        toView?.alpha = 1
        
        toView?.frame = CGRect(x: 0, y: 0, width: (fromView?.frame.size.width)!, height: (fromView?.frame.size.height)!)
        toView?.center = CGPoint(x: (fromView?.center.x)!, y: (fromView?.center.y)!)
        
        let toTheRight = CGAffineTransform(translationX: (toView?.frame.width)!, y: 0)
        let toTheLeft = CGAffineTransform(translationX: -(toView?.frame.width)!, y: 0)
        
        // set the start location of toView depending if we're presenting or not
        toView?.transform = self.forward ? toTheRight : toTheLeft
        
        // add the both views to our view controller
        container.addSubview(toView!)
        container.addSubview(fromView!)
        
        // get the duration of the animation
        let duration = self.transitionDuration(using: transitionContext)
        
        let options = interactive ? UIViewAnimationOptions.curveLinear : UIViewAnimationOptions.curveEaseOut
        
        // perform the animation
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            
            // set the end location of fromView depending if we're presenting or not
            fromView?.transform = self.forward ? toTheLeft : toTheRight
            toView?.transform = CGAffineTransform.identity
            
        }, completion: { finished in
            
            if(transitionContext.transitionWasCancelled){
                transitionContext.completeTransition(false)
            }
            else {
                transitionContext.completeTransition(true)
            }
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        })
    }
}
