//
//  BaseView.swift
//  Pods-PVDBaseMVC_Tests
//
//  Created by Вадим Попов on 11/9/17.
//

import Foundation
import UIKit

/**
 *
 *
 */
open class BaseView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    public init() {
        super.init(frame: .zero)
        self.createViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createViews()
    }
    
    /**
     */
    open func createViews() {}
}
