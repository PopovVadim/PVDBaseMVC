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
public class BaseViewController: UIViewController {
    
    // MARK: Models
    
    ///
    class var identifier: String {
        return ""
    }
    
    ///
    internal var _vcForTransition: UIViewController!
    public var vcForTransition: UIViewController {
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
    internal var nc: BaseNavigationController? {
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
    var statusBarStyle: UIStatusBarStyle {
        get {
            return self.preferredStatusBarStyle
        }
        set {
            self.preferredStatusBarStyle = newValue
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    ///
    var isDisplaying: Bool = false
    
    ///
    internal var viewToBlur: UIView {
        get {
            return self.view
        }
    }
    
    ///
    internal var blurStyle: UIBlurEffectStyle {
        get {
            return .extraLight
        }
    }
    
    ///
    internal var acColor: UIColor {
        return UIColor.darkGray
    }
    
    internal class var optionsNames: [String] {
        return []
    }
    
    ///
    internal var optionsActions: [String: (Any) -> Void] {
        return [:]
    }
    
    var hoveredViews: [HoverStyle : [UIView]] = [:]
    internal var blurView: UIVisualEffectView!
    private var ac: UIActivityIndicatorView!
    
    var executingRequest: Int?
    var cancelledRequests: [Int] = []
    
    /**
     */
    class func instantiate(makingOptionsWith args: Any...) -> BaseViewController {
        let vc = BaseViewController()
        vc.initWithOptions(makeOptions(args: args))
        return vc
    }
    
    /**
     */
    internal func initWithOptions(_ options: [String: Any]) {
        for (key, value) in options {
            guard let function = optionsActions[key] else {
                continue
            }
            function(value)
        }
    }
    
    /**
     */
    internal class func makeOptions(args: [Any]) -> [String: Any] {
        var options: [String : Any] = [:]
        for i in 0 ..< args.count {
            options[optionsNames[i]] = args[i]
        }
        return options
    }
    
    /**
     * To be overriden
     */
    @objc func appDidBecomeActive() {}
    
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
    func push(vc: UIViewController, animated: Bool = true) {
        self.vcForTransition.navigationController?.pushViewController(vc, animated: animated)
    }
    
    /**
     */
    func pop(animated: Bool = true) -> UIViewController? {
        return self.vcForTransition.navigationController?.popViewController(animated: animated)
    }
    
    /**
     * To be overriden
     */
    func createViews() {}
    
    /**
     */
    func cancelCurrentRequest() {
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
    func executingRequest(having id: Int) -> Bool {
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
    func hover(touch: UITouch) {
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
    func unhover() {
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
    func apply(animations: @escaping (() -> Void), animated: Bool, completion: ((Bool) -> Void)?) {
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
    func applyBlur(duration: Double = 0.3) {
        
        if blurView == nil {
            blurView = UIVisualEffectView()
            viewToBlur.addSubview(blurView)
        }
        blurView.effect = UIBlurEffect(style: blurStyle)
        blurView.alpha = 0
        blurView.frame = viewToBlur.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.fadeIn()
    }
    
    /**
     */
    func removeBlur(duration: Double = 0.3) {
        self.blurView.fadeOut()
    }
    
    /**
     */
    func startLoadingAnimation(withBlur: Bool = true) {
        if withBlur {
            self.applyBlur()
        }
        if self.ac == nil {
            self.ac = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            ac.hidesWhenStopped = true
            self.view.addSubview(ac)
        }
        ac.color = self.acColor
        ac.startAnimating()
        ac.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    func stopLoadingAnimation() {
        self.removeBlur()
        if self.ac != nil {
            self.ac.stopAnimating()
        }
    }
    
    /**
     */
    @objc func backTap(_ sender: UIButton) {
        self.view.endEditing(true)
        pop()
    }
    
    
}
