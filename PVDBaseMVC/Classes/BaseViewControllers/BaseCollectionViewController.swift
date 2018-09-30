//
//  BaseCollectionViewController.swift
//  Pods-PVDBaseMVC_Tests
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation
import UIKit
import PVDSwiftAddOns

/**
 *
 *
 */
public protocol CollectionViewOwner: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Registered reusable views
    var registeredIdentifiers: Set<String> {get set}
    var registeredHeaderIdentifiers: Set<String> {get set}
    var registeredFooterIdentifiers: Set<String> {get set}
    
    // MARK: Views
    var collectionView: UICollectionView! {get set}
    var refreshControl: UIRefreshControl! {get set}
    var collectionViewParent: UIView {get}
    var viewForRefreshControl: UIScrollView {get}
    
    // MARK: Collection params
    var collectionViewFrame: CGRect {get}
    var minimumFooterHeightForLastSection: CGFloat {get set}
    var minimumHeaderHeightForFirstSection: CGFloat {get set}
    var layout: UICollectionViewFlowLayout {get}
    
    // MARK: Flags
    var hasRefreshControl: Bool {get}
    
    // MARK: Models
    var sectionModels: [BaseCollectionSectionModel] {get}
    
    // MARK: Functions
    func registerReusableViews()
    func refresh(withLoadingAnimation: Bool)
}

/**
 *
 *
 */
open class BaseCollectionViewController: BaseViewController, CollectionViewOwner {
    
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
        return self.view
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
        return self.view.bounds
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
    
    /**
     */
    open override func createViews() {
        super.createViews()
        
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
 *
 *
 */
extension BaseCollectionViewController : UICollectionViewDataSource {
    
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
            let headerModel = sectionModels[indexPath.section].headerModel ?? BaseCollectionReusableModel(size: CGSize(width: self.collectionView.width(), height: 0))
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerModel.identifier, for: indexPath) as! BaseCollectionReusableView
            reusableView.model = headerModel
            break
            
        case UICollectionView.elementKindSectionFooter:
            let footerModel = sectionModels[indexPath.section].footerModel ?? BaseCollectionReusableModel(size: CGSize(width: self.collectionView.width(), height: 0))
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
 *
 *
 */
extension BaseCollectionViewController : UICollectionViewDelegateFlowLayout {
    
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
            return isFirstSection ? CGSize(width: self.view.width(), height: minimumHeaderHeightForFirstSection) : CGSize.zero
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
            return isLastSection ? CGSize(width: self.view.width(), height: minimumFooterHeightForLastSection) : CGSize.zero
        }
        var size = footerModel.size
        if isLastSection && size.height < minimumFooterHeightForLastSection {
            size = CGSize(width: size.width, height: minimumFooterHeightForLastSection)
        }
        return size
    }
}
