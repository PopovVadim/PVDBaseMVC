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
import SDWebImage

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
        guard
            let pvdDict = Bundle.main.object(forInfoDictionaryKey: "PVD") as? [String: Any],
            let value = pvdDict["cellsShouldHaveBottomLine"] as? Bool
        else {
            return false
        }
        return value
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
    
    ///
    open var hoveredViews: [HoverStyle : [UIView]] = [:]
    
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
        
        self.backgroundColor = localModel.backgroundColor
        
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
        label.apply(localModel.textDescriptor)
        label.attributedText = localModel.text
        label.snp.updateConstraints({ make in
            make.left.equalToSuperview().inset(localModel.insets.left)
            make.right.equalToSuperview().inset(localModel.insets.right)
            make.top.equalToSuperview().inset(localModel.insets.top)
            make.bottom.equalToSuperview().inset(localModel.insets.bottom)
        })
    }
}

/**
 *
 *
 */
open class BaseCellWithCollectionView: BaseCollectionCellView, CollectionViewOwner {
    
    ///
    open var localModel: BaseCellWithCollectionModel {
        return self.model as! BaseCellWithCollectionModel
    }
    
    ///
    open var registeredIdentifiers: Set<String> = Set()
    
    ///
    open var registeredHeaderIdentifiers: Set<String> = Set()
    
    ///
    open var registeredFooterIdentifiers: Set<String> = Set()
    
    ///
    open var collectionView: UICollectionView!
    
    ///
    open var refreshControl: UIRefreshControl!
    
    ///
    open var collectionViewParent: UIView {
        return self.contentView
    }
    
    ///
    open var viewForRefreshControl: UIScrollView {
        return self.collectionView
    }
    
    ///
    open var scrollViewForRefreshControl: UIScrollView {
        return self.collectionView
    }
    
    ///
    open var sectionModels: [BaseCollectionSectionModel] {
        return []
    }
    
    ///
    open var collectionViewFrame: CGRect {
        return self.bounds
    }
    
    ///
    private var _minimumFooterHeightForLastSection: CGFloat = 0.0
    open var minimumFooterHeightForLastSection: CGFloat {
        get {
            return _minimumFooterHeightForLastSection
        }
        set {
            _minimumFooterHeightForLastSection = newValue
        }
    }
    
    ///
    private var _minimumHeaderHeightForFirstSection: CGFloat = 0.0
    open var minimumHeaderHeightForFirstSection: CGFloat {
        get {
            return _minimumHeaderHeightForFirstSection
        }
        set {
            _minimumHeaderHeightForFirstSection = newValue
        }
    }
    
    ///
    open var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    ///
    open var hasRefreshControl: Bool {
        return false
    }
    
    ///
    open var refreshControlColor: UIColor {
        return UIColor.darkGray
    }
    
    override open func setup() {
        guard !didSetup else {
            updateUI()
            return
        }
        
        // Collection view
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        self.registerReusableViews()
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        self.collectionViewParent.insertSubview(self.collectionView, at: 0)
        
        self.refreshControl = UIRefreshControl()
        refreshControl.tintColor = refreshControlColor
        if #available(iOS 10.0, *), hasRefreshControl {
            self.refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
            self.scrollViewForRefreshControl.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        super.setup()
    }
    
    /**
     */
    override open func updateUI() {
        if self.collectionView != nil {
            self.collectionView.reloadData()
        }
    }
    
    /**
     */
    open func refresh(withLoadingAnimation: Bool = true) {}
    
    /**
     */
    open func registerReusableViews() {
        for section in self.sectionModels {
            for cellModel in section.cellModels {
                if registeredIdentifiers.contains(cellModel.cellIdentifier) {
                    continue
                }
                collectionView.register(cellModel.viewClass, forCellWithReuseIdentifier: cellModel.cellIdentifier)
            }
            if let headerModel = section.headerModel,
                !registeredHeaderIdentifiers.contains(headerModel.identifier) {
                collectionView.register(headerModel.viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerModel.identifier)
            }
            if let footerModel = section.footerModel,
                !registeredFooterIdentifiers.contains(footerModel.identifier) {
                collectionView.register(footerModel.viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerModel.identifier)
            }
        }
        
        let baseReusableModel = BaseCollectionReusableModel(size: CGSize(width: self.collectionView.width(), height: 0))
        if !registeredHeaderIdentifiers.contains(baseReusableModel.identifier) {
            collectionView.register(baseReusableModel.viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: baseReusableModel.identifier)
        }
        if !registeredFooterIdentifiers.contains(baseReusableModel.identifier) {
            collectionView.register(baseReusableModel.viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: baseReusableModel.identifier)
        }
    }
    
    /**
     */
    @objc open func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        if refreshControl.isRefreshing {
            self.refresh(withLoadingAnimation: false)
        }
    }
}

/**
 * `UICollectionViewDataSource` conformance
 */
extension BaseCellWithCollectionView {
    
    /**
     */
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionModels.count
    }
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let models = sectionModels
        return models[section].cellModels.count
    }
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let model = sectionModels[section].cellModels[row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier, for: indexPath) as? BaseCollectionCellView {
            cell.isLast = row == sectionModels[section].cellModels.count - 1
            cell.model = model
            cell.setup()
            return cell
        }
        return BaseCollectionCellView()
    }
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = BaseCollectionReusableView()
        guard indexPath.section < self.sectionModels.count else {
            return reusableView
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerModel = sectionModels[indexPath.section].headerModel ?? BaseCollectionReusableModel(size: CGSize(width: 0, height: 0))
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerModel.identifier, for: indexPath) as! BaseCollectionReusableView
            reusableView.model = headerModel
            break
            
        case UICollectionView.elementKindSectionFooter:
            let footerModel = sectionModels[indexPath.section].footerModel ?? BaseCollectionReusableModel(size: CGSize(width: 0, height: 0))
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerModel.identifier, for: indexPath) as! BaseCollectionReusableView
            reusableView.model = footerModel
            break
            
        default:
            return reusableView
        }
        
        reusableView.setup()
        return reusableView
    }
}

/**
 * `UICollectionViewDelegateFlowLayout` conformance
 */
extension BaseCellWithCollectionView {
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = sectionModels[indexPath.section].cellModels[indexPath.row]
        return model.size
    }
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let isFirstSection = section == 0
        guard let headerModel = sectionModels[section].headerModel else {
            return isFirstSection ? CGSize(width: 0, height: minimumHeaderHeightForFirstSection) : CGSize.zero
        }
        var size = headerModel.size
        if isFirstSection && size.height < minimumHeaderHeightForFirstSection {
            size = CGSize(width: size.width, height: minimumHeaderHeightForFirstSection)
        }
        return size
    }
    
    /**
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let isLastSection = section == numberOfSections(in: collectionView) - 1
        guard let footerModel = sectionModels[section].footerModel else {
            return isLastSection ? CGSize(width: 0, height: minimumFooterHeightForLastSection) : CGSize.zero
        }
        var size = footerModel.size
        if isLastSection && size.height < minimumFooterHeightForLastSection {
            size = CGSize(width: size.width, height: minimumFooterHeightForLastSection)
        }
        return size
    }
}

/**
 *
 *
 */
open class ImageCellView: BaseCollectionCellView {
    
    ///
    open var localModel: ImageCellModel {
        return model as! ImageCellModel
    }
    
    ///
    open var imageView: UIImageView!
    
    /**
     */
    override open func setup() {
        guard !didSetup else {
            updateUI()
            return
        }
        
        imageView = UIImageView()
        imageView.backgroundColor = localModel.backgroundColor
        imageView.contentMode = localModel.contentMode
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        super.setup()
    }
    
    /**
     */
    override open func updateUI() {
        super.updateUI()
        
        imageView.snp.remakeConstraints({ make in
            if let size = localModel.imageSize {
                make.center.equalToSuperview()
                make.size.equalTo(size)
            }
            else {
                make.top.bottom.left.right.equalToSuperview()
            }
        })
        
        if let image = localModel.image {
            imageView.image = image
        }
        else {
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setImage(with: localModel.imageURL, completed: nil)
        }
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


