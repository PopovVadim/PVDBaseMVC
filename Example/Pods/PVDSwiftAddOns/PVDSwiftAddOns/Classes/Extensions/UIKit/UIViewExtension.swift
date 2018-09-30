//
//  UIViewExtension.swift
//  PVDSwiftExtensions
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 */
public func == (lhs: HoverStyle, rhs: HoverStyle) -> Bool {
    return lhs.toInt() == rhs.toInt()
}

/**
 *
 *
 */
public enum HoverStyle: Hashable {
    
    ////
    public var hashValue: Int {
        return self.toInt()
    }
    
    case push
    case shiftRight
    case transform(() -> Void)
    
    /**
     */
    func toInt() -> Int {
        switch self {
        case .push:
            return 0
        case .shiftRight:
            return 1
        case .transform(_):
            return 2
        }
    }
    
    /**
     */
    func applyHover(to view: UIView, duration: Double = 0.1, sender: Any? = nil) {
        switch self {
        case .transform(let animations):
            animate(view, duration: duration, animations: animations)
            break
        case .push:
            animate(view, duration: duration, animations: {
                view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            })
            break
        case .shiftRight:
            animate(view, duration: duration, animations: {
                view.transform = CGAffineTransform(translationX: 10.0, y: 0)
            })
            break
        }
    }
    
    /**
     */
    func applyUnhover(to view: UIView, duration: Double = 0.1, sender: Any? = nil) {
        switch self {
        default:
            animate(view, duration: duration, animations: {
                view.transform = CGAffineTransform.identity
            })
            break
        }
    }
    
    /**
     */
    private func animate(_ view: UIView, duration: Double = 0.1, animations: @escaping (() -> Void)) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: animations, completion: nil)
    }
}

/**
 *
 *
 */
public extension UIView {
    
    /**
     */
    public func height() -> CGFloat {
        return self.frame.height
    }
    
    /**
     */
    public func width() -> CGFloat {
        return self.frame.width
    }
    
    /**
     */
    public func x() -> CGFloat {
        return self.frame.minX
    }
    
    /**
     */
    public func y() -> CGFloat {
        return self.frame.minY
    }
    
    /**
     */
    public func maxX() -> CGFloat {
        return self.frame.maxX
    }
    
    /**
     */
    public func maxY() -> CGFloat {
        return self.frame.maxY
    }
    
    /**
     */
    public func size() -> CGSize {
        return self.frame.size
    }
    
    /**
     */
    public func origin() -> CGPoint {
        return self.frame.origin
    }
    
    /**
     */
    public func setHeight(_ value: CGFloat) {
        self.frame = CGRect(origin: self.origin(), size: CGSize(width: self.width(), height: value))
    }

    /**
     */
    public func setWidth(_ value: CGFloat) {
        self.frame = CGRect(origin: self.origin(), size: CGSize(width: value, height: self.height()))
    }

    /**
     */
    public func setX(_ value: CGFloat) {
        self.frame = CGRect(origin: CGPoint(x: value, y: self.y()), size: self.size())
    }
    
    /**
     */
    public func setY(_ value: CGFloat) {
        self.frame = CGRect(origin: CGPoint(x: self.x(), y: value), size: self.size())
    }
    
    /**
     */
    public func applyRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    /**
     */
    public func makeRound() {
        layer.cornerRadius = self.width()/2
    }
    
    /**
     */
    public func applyShadow(_ color: UIColor, _ offset: CGSize = CGSize.zero, _ radius: CGFloat = 10.0, _ opacity: Float = 1.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    /**
     */
    public func applyBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /**
     */
    public func hover(with touch: UITouch, style: HoverStyle = .push, duration: Double = 0.3) {
        if self.point(inside: touch.location(in: self), with: nil) {
            style.applyHover(to: self, duration: duration)
        }
        else {
            unhover(style: style, duration: duration)
        }
    }
    
    /**
     */
    public func unhover(style: HoverStyle = .push, duration: Double = 0.3) {
        style.applyUnhover(to: self, duration: duration)
    }
    
    /**
     */
    public func shake(duration: Double = 0.5, amplitude: CGFloat = 10.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                self.transform = CGAffineTransform(translationX: amplitude, y: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: -0.8 * amplitude, y: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.20, animations: {
                self.transform = CGAffineTransform(translationX: 0.5 * amplitude, y: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.15, animations: {
                self.transform = CGAffineTransform(translationX: -0.2 * amplitude, y: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }, completion: completion)
    }
    
    /**
     */
    public func blink(duration: Double = 0.5, fromAlpha: CGFloat? = nil, toAlpha: CGFloat = 1.0, completion: ((Bool) -> Void)? = nil) {
        var fa = fromAlpha
        if fa == nil {
            fa = self.alpha
        }
        UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = toAlpha
        }, completion: { Void in
            UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = fa!
            }, completion: completion)
        })
    }
    
    /**
     */
    public func blink(with color: UIColor, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil) {
        let initialColor = self.backgroundColor
        UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundColor = color
        }, completion: { Void in
            UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseOut, animations: {
                self.backgroundColor = initialColor
            }, completion: completion)
        })
    }
    
    /**
     */
    public func fadeIn(duration: Double = 0.3, alpha: CGFloat = 1.0, completion: (() -> Void)? = nil) {
        fade(with: duration, to: alpha, completion: completion)
    }
    
    /**
     */
    public func fadeOut(duration: Double = 0.3, alpha: CGFloat = 0.0, completion: (() -> Void)? = nil) {
        fade(with: duration, to: alpha, completion: completion)
    }
    
    /**
     */
    public func fade(with duration: Double = 0.3, to alpha: CGFloat, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }, completion: {_ in
            completion?()
        })
    }
    
    /**
     */
    public func setHidden(_ hidden: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            if hidden {
                self.fadeOut() {
                    self.isHidden = true
                    completion?()
                }
            }
            else {
                self.isHidden = false
                self.fadeIn(completion: completion)
            }
        }
        else {
            self.alpha = hidden ? 0 : 1
            self.isHidden = hidden
            completion?()
        }
    }
}
