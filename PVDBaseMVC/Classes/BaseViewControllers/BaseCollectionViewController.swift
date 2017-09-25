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
public class BaseCollectionViewController: BaseViewController {
    
    ///
    var registeredIdentifiers: Set<String> = Set()
    
    ///
    var registeredHeaderIdentifiers: Set<String> = Set()
    
    ///
    var registeredFooterIdentifiers: Set<String> = Set()
    
    ///
    var collectionView: UICollectionView!
    
    ///
    private var _refreshControl: UIRefreshControl!
    var refreshControl: UIRefreshControl {
        get {
            return _refreshControl
        }
        set {
            _refreshControl = newValue
        }
    }
    
    ///
    var refreshControlColor: UIColor {
        return UIColor.darkGray
    }
    
    ///
    var sectionModels: [BaseCollectionSectionModel] {
        return []
    }
    
    ///
    var collectionViewParent: UIView {
        return self.view
    }
    
    ///
    var collectionViewFrame: CGRect {
        return self.view.bounds
    }
    
    ///
    private var _minimumFooterHeightForLastSection: CGFloat = 50.0
    var minimumFooterHeightForLastSection: CGFloat {
        get {
            return _minimumFooterHeightForLastSection
        }
        set {
            _minimumFooterHeightForLastSection = newValue
        }
    }
    
    ///
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    /**
     */
    override func createViews() {
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
        if #available(iOS 10.0, *) {
            self.refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
            self.collectionView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    
    /**
     */
    func refresh(withLoadingAnimation: Bool = true) {}
    
    /**
     */
    internal func registerReusableViews() {
        for section in self.sectionModels {
            for cellModel in section.cellModels {
                if registeredIdentifiers.contains(cellModel.cellIdentifier) {
                    continue
                }
                collectionView.register(cellModel.viewClass, forCellWithReuseIdentifier: cellModel.cellIdentifier)
            }
            if let headerModel = section.headerModel,
                !registeredHeaderIdentifiers.contains(headerModel.identifier) {
                collectionView.register(headerModel.viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerModel.identifier)
            }
            if let footerModel = section.footerModel,
                !registeredFooterIdentifiers.contains(footerModel.identifier) {
                collectionView.register(footerModel.viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerModel.identifier)
            }
        }
        
        let baseReusableModel = BaseCollectionReusableModel(size: CGSize(width: self.collectionView.width(), height: 0))
        if !registeredHeaderIdentifiers.contains(baseReusableModel.identifier) {
            collectionView.register(baseReusableModel.viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: baseReusableModel.identifier)
        }
        if !registeredFooterIdentifiers.contains(baseReusableModel.identifier) {
            collectionView.register(baseReusableModel.viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: baseReusableModel.identifier)
        }
    }
    
    /**
     */
    @objc func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
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
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionModels.count
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let models = sectionModels
        return models[section].cellModels.count
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = BaseCollectionReusableView()
        guard indexPath.section < self.sectionModels.count else {
            return reusableView
        }
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerModel = sectionModels[indexPath.section].headerModel ?? BaseCollectionReusableModel(size: CGSize(width: self.collectionView.width(), height: 0))
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerModel.identifier, for: indexPath) as! BaseCollectionReusableView
            reusableView.model = headerModel
            break
            
        case UICollectionElementKindSectionFooter:
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
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = sectionModels[indexPath.section].cellModels[indexPath.row]
        return model.size
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let headerModel = sectionModels[section].headerModel else {
            return CGSize.zero
        }
        return headerModel.size
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
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
