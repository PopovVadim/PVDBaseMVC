//
//  BaseCollectionModels.swift
//  Pods-PVDBaseMVC_Tests
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation

/**
 *
 *
 */
open class BaseCollectionSectionModel {
    
    ///
    open var headerModel: BaseCollectionHeaderModel?
    ///
    open var footerModel: BaseCollectionFooterModel?
    ///
    open var cellModels: [BaseCollectionCellModel] = []
    
    /**
     */
    public init(headerModel: BaseCollectionHeaderModel? = nil, cellModels: [BaseCollectionCellModel] = [], footerModel: BaseCollectionFooterModel? = nil) {
        self.headerModel = headerModel
        self.footerModel = footerModel
        self.cellModels = cellModels
    }
}

/**
 *
 *
 */
open class BaseCollectionCellModel {
    
    ///
    open var cellIdentifier: String {
        return ""
    }
    
    ///
    open var viewClass: AnyClass? {
        return BaseCollectionCellView.self
    }
    
    ///
    open var size: CGSize {
        return CGSize.zero
    }
}

/**
 *
 *
 */
open class BaseCollectionReusableModel {
    
    ///
    open var identifier: String {
        return "base_collection_reusable_view"
    }
    
    ///
    open var viewClass: AnyClass? {
        return BaseCollectionReusableView.self
    }
    
    ///
    private var _size: CGSize = CGSize.zero
    open var size: CGSize {
        get {
            return _size
        }
        set {
            _size = newValue
        }
    }
    
    /**
     */
    public init(size: CGSize = CGSize.zero) {
        self._size = size
    }
}

/**
 *
 *
 */
open class BaseCollectionHeaderModel : BaseCollectionReusableModel {
    
    ///
    override open var identifier: String {
        return "base_collection_header"
    }
    
    ///
    override open var viewClass: AnyClass? {
        return BaseCollectionHeaderView.self
    }
}

/**
 *
 *
 */
open class BaseCollectionFooterModel : BaseCollectionReusableModel {
    
    ///
    override open var identifier: String {
        return "base_collection_footer"
    }
    
    ///
    override open var viewClass: AnyClass? {
        return BaseCollectionFooterView.self
    }
}

