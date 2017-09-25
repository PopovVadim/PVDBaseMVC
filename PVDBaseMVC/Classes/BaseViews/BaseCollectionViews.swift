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
public class BaseCollectionCellView : UICollectionViewCell {
    
    ///
    var model: BaseCollectionCellModel!
    
    ///
    var bottomSplitter: UIView!
    
    ///
    var hasBottomSplitter: Bool {
        return true
    }
    
    ///
    var leftInset: CGFloat {
        return 20
    }
    
    ///
    var rightInset: CGFloat {
        return -20
    }
    
    ///
    var splitterHeight: CGFloat {
        return 0.5
    }
    
    ///
    var splitterColor: UIColor {
        return UIColor.lightGray
    }
    
    ///
    var isLast: Bool = false {
        didSet {
            updateBottomSplitter()
        }
    }
    
    ///
    var didSetup: Bool = false
    
    /**
     */
    func setup() {
        updateUI()
        didSetup = true
    }
    
    /**
     */
    func updateUI() {
        updateBottomSplitter()
    }
    
    /**
     */
    private func updateBottomSplitter() {
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

// MARK: - Collection reusable views

/**
 *
 *
 */
public class BaseCollectionReusableView : UICollectionReusableView {
    
    ///
    var model: BaseCollectionReusableModel!
    
    ///
    var didSetup: Bool = false
    
    /**
     */
    func setup() {
        updateUI()
        didSetup = true
    }
    
    /**
     */
    func updateUI() {}
}

/**
 *
 *
 */
public class BaseCollectionHeaderView : BaseCollectionReusableView {}

/**
 *
 *
 */
public class BaseCollectionFooterView : BaseCollectionReusableView {}


