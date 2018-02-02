//
//  BaseViewController.swift
//  Pods-PVDStarterPackSwiftUI_Tests
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation
import UIKit
import SnapKit
import PVDSwiftAddOns

/**
 *
 *
 */
open class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    ///
    internal var _vcForTransition: UIViewController!
    open var vcForTransition: UIViewController {
        get {
            if _vcForTransition == nil {
                _vcForTransition = self
            }
            return _vcForTransition
        }
        set {
            _vcForTransition = newValue
        }
    }
    
    ///
    open var nc: BaseNavigationController? {
        return self.navigationController as? BaseNavigationController
    }
    
    ///
    private var _preferredStatusBarStyle: UIStatusBarStyle!
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if _preferredStatusBarStyle == nil {
                _preferredStatusBarStyle = super.preferredStatusBarStyle
            }
            return _preferredStatusBarStyle
        }
        set {
            _preferredStatusBarStyle = newValue
        }
    }
    
    ///
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    ///
    open var statusBarStyle: UIStatusBarStyle {
        get {
            return self.preferredStatusBarStyle
        }
        set {
            self.preferredStatusBarStyle = newValue
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    ///
    open var isDisplaying: Bool = false
    
    ///
    open var viewToBlur: UIView {
        get {
            return self.view
        }
    }
    
    ///
    open var blurStyle: UIBlurEffectStyle {
        get {
            return .extraLight
        }
    }
    
    ///
    open var activityIndicatorColor: UIColor {
        return UIColor.darkGray
    }
    
    open class var optionsNames: [String] {
        return []
    }
    
    ///
    open var optionsActions: [String: (Any) -> Void] {
        return [:]
    }
    
    open var hoveredViews: [HoverStyle : [UIView]] = [:]
    open var blurView: UIVisualEffectView!
    open var activityIndicator: UIActivityIndicatorView!
    
    open var executingRequest: Int?
    open var cancelledRequests: [Int] = []
    
    /**
     */
    open class func instantiate(makingOptionsWith args: Any...) -> BaseViewController {
        let vc = BaseViewController()
        vc.initWithOptions(makeOptions(args: args))
        return vc
    }
    
    /**
     *
     */
    open func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    /**
     */
    open func initWithOptions(_ options: [String: Any]) {
        for (key, value) in options {
            guard let function = optionsActions[key] else {
                continue
            }
            function(value)
        }
    }
    
    /**
     */
    open class func makeOptions(args: [Any]) -> [String: Any] {
        var options: [String : Any] = [:]
        for i in 0 ..< args.count {
            options[optionsNames[i]] = args[i]
        }
        return options
    }
    
    /**
     * To be overriden
     */
    @objc open func appDidBecomeActive() {}
    
    /**
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        createViews()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    /**
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDisplaying = true
    }
    
    /**
     */
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isDisplaying = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    /**
     */
    open override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if isDisplaying {
            super.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    /**
     */
    open func push(vc: UIViewController, forceSelf: Bool = false, animated: Bool = true) {
        if forceSelf {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
        else {
            self.vcForTransition.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    /**
     */
    open func pop(animated: Bool = true) -> UIViewController? {
        return self.vcForTransition.navigationController?.popViewController(animated: animated)
    }
    
    /**
     * To be overriden
     */
    open func createViews() {}
    
    /**
     */
    open func cancelCurrentRequest() {
        guard let id = self.executingRequest else {
            return
        }
        if self.executingRequest != nil {
            self.cancelledRequests.append(id)
        }
        self.executingRequest = nil
    }
    
    /**
     */
    open func executingRequest(having id: Int) -> Bool {
        if self.cancelledRequests.contains(id) {
            self.cancelledRequests.remove(at: self.cancelledRequests.index(of: id)!)
            return false
        }
        self.executingRequest = nil
        return true
    }
    
    /**
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hover(touch: touches.first!)
    }
    
    /**
     */
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhover()
    }
    
    /**
     */
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unhover()
    }
    
    /**
     */
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        hover(touch: touches.first!)
    }
    
    /**
     */
    open func hover(touch: UITouch) {
        for style in hoveredViews.keys {
            if hoveredViews[style] == nil {
                continue
            }
            for view in hoveredViews[style]! {
                view.hover(with: touch, style: style)
            }
        }
    }
    
    /**
     */
    open func unhover() {
        for style in hoveredViews.keys {
            if hoveredViews[style] == nil {
                continue
            }
            for view in hoveredViews[style]! {
                view.unhover(style: style)
            }
        }
    }
    
    /**
     */
    open func apply(animations: @escaping (() -> Void), animated: Bool, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
        }
        else {
            execute {
                animations()
                if completion != nil {
                    completion!(true)
                }
            }
        }
    }
    
    /**
     */
    open func applyBlur(animated: Bool = true, duration: Double = 0.3) {
        if blurView == nil {
            blurView = UIVisualEffectView()
            viewToBlur.addSubview(blurView)
        }
        blurView.effect = UIBlurEffect(style: blurStyle)
//        blurView.alpha = 0
        blurView.frame = viewToBlur.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if animated {
            blurView.fadeIn()
        }
        else {
            blurView.alpha = 1
        }
    }
    
    /**
     */
    open func removeBlur(animated: Bool = true, duration: Double = 0.3) {
        guard blurView != nil else {
            return
        }
        if animated {
            self.blurView.fadeOut()
        }
        else {
            self.blurView.alpha = 0
        }
    }
    
    /**
     */
    open func startLoadingAnimation(animated: Bool = true, withBlur: Bool = true) {
        if withBlur {
            self.applyBlur(animated: animated)
        }
        if self.activityIndicator == nil {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
        }
        activityIndicator.color = self.activityIndicatorColor
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    /**
     */
    open func stopLoadingAnimation(animated: Bool = true) {
        self.removeBlur(animated: animated)
        if self.activityIndicator != nil {
            self.activityIndicator.stopAnimating()
        }
    }
    
    /**
     */
    @objc open func backTap(_ sender: UIButton) {
        self.view.endEditing(true)
        let _ = pop()
    }
    
    /**
     */
    open func add(childVC viewController: UIViewController, to view: UIView) {
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        viewController.view.snp.makeConstraints({ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        })
    }
    
    /**
     */
    open func remove(childVC viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
