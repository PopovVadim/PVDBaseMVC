//
//  BaseCollectionViews.swift
//  Pods-PVDBaseMVC_Tests
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
open class BaseCollectionCellView : UICollectionViewCell {
    
    ///
    open var model: BaseCollectionCellModel!
    
    ///
    open var bottomSplitter: UIView!
    
    ///
    open var hasBottomSplitter: Bool {
        return true
    }
    
    ///
    open var leftInset: CGFloat {
        return 20
    }
    
    ///
    open var rightInset: CGFloat {
        return -20
    }
    
    ///
    open var splitterHeight: CGFloat {
        return 0.5
    }
    
    ///
    open var splitterColor: UIColor {
        return UIColor.lightGray
    }
    
    ///
    open var isLast: Bool = false {
        didSet {
            updateBottomSplitter()
        }
    }
    
    ///
    open var didSetup: Bool = false
    
    /**
     */
    open func setup() {
        updateUI()
        didSetup = true
    }
    
    /**
     */
    open func updateUI() {
        updateBottomSplitter()
    }
    
    /**
     */
    open func updateBottomSplitter() {
        if hasBottomSplitter && !isLast {
            if self.bottomSplitter != nil {
                self.bottomSplitter.removeFromSuperview()
            }
            self.bottomSplitter = UIView()
            bottomSplitter.alpha = 0
            bottomSplitter.backgroundColor = splitterColor
            self.addSubview(bottomSplitter)
            bottomSplitter.snp.makeConstraints({ make in
                make.left.equalToSuperview().offset(leftInset)
                make.right.equalToSuperview().offset(rightInset)
                make.bottom.equalToSuperview()
                make.height.equalTo(splitterHeight)
            })
            bottomSplitter.fadeIn()
        }
        else if let bs = self.bottomSplitter {
            bs.fadeOut() {
                bs.removeFromSuperview()
            }
        }
    }
}

/**
 *
 *
 */
open class BaseCollectionTextCellView: BaseCollectionCellView {
    
    ///
    internal var localModel: BaseCollectionTextCellModel {
        return model as! BaseCollectionTextCellModel
    }
    
    ///
    override open var hasBottomSplitter: Bool {
        return false
    }
    
    ///
    open var label: UILabel!
    
    /**
     */
    override open func setup() {
        guard !didSetup else {
            updateUI()
            return
        }
        
        label = UILabel()
        label.apply(localModel.textDescriptor)
        self.addSubview(label)
        label.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(localModel.insets.left)
            make.right.equalToSuperview().inset(localModel.insets.right)
            make.top.equalToSuperview().inset(localModel.insets.top)
            make.bottom.equalToSuperview().inset(localModel.insets.bottom)
        })
        
        super.setup()
    }
    
    /**
     */
    override open func updateUI() {
        super.updateUI()
        label.text = localModel.text
        label.apply(localModel.textDescriptor)
        label.snp.updateConstraints({ make in
            make.left.equalToSuperview().inset(localModel.insets.left)
            make.right.equalToSuperview().inset(localModel.insets.right)
            make.top.equalToSuperview().inset(localModel.insets.top)
            make.bottom.equalToSuperview().inset(localModel.insets.bottom)
        })
    }
}

// MARK: - Collection reusable views

/**
 *
 *
 */
open class BaseCollectionReusableView : UICollectionReusableView {
    
    ///
    open var model: BaseCollectionReusableModel!
    
    ///
    open var didSetup: Bool = false
    
    /**
     */
    open func setup() {
        updateUI()
        didSetup = true
    }
    
    /**
     */
    open func updateUI() {}
}

/**
 *
 *
 */
open class BaseCollectionHeaderView : BaseCollectionReusableView {}

/**
 *
 *
 */
open class BaseCollectionFooterView : BaseCollectionReusableView {}


