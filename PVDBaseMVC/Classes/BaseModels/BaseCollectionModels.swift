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
public class BaseCollectionSectionModel {
    
    ///
    var headerModel: BaseCollectionHeaderModel?
    ///
    var footerModel: BaseCollectionFooterModel?
    ///
    var cellModels: [BaseCollectionCellModel] = []
    
    /**
     */
    init(headerModel: BaseCollectionHeaderModel? = nil, cellModels: [BaseCollectionCellModel] = [], footerModel: BaseCollectionFooterModel? = nil) {
        self.headerModel = headerModel
        self.footerModel = footerModel
        self.cellModels = cellModels
    }
}

/**
 *
 *
 */
public class BaseCollectionCellModel {
    
    ///
    var cellIdentifier: String {
        return ""
    }
    
    ///
    var viewClass: AnyClass? {
        return BaseCollectionCellView.self
    }
    
    ///
    var size: CGSize {
        return CGSize.zero
    }
}

/**
 *
 *
 */
public class BaseCollectionReusableModel {
    
    ///
    var identifier: String {
        return "base_collection_reusable_view"
    }
    
    ///
    var viewClass: AnyClass? {
        return BaseCollectionReusableView.self
    }
    
    ///
    private var _size: CGSize = CGSize.zero
    var size: CGSize {
        get {
            return _size
        }
        set {
            _size = newValue
        }
    }
    
    /**
     */
    init(size: CGSize = CGSize.zero) {
        self._size = size
    }
}

/**
 *
 *
 */
public class BaseCollectionHeaderModel : BaseCollectionReusableModel {
    
    ///
    override var identifier: String {
        return "base_collection_header"
    }
    
    ///
    override var viewClass: AnyClass? {
        return BaseCollectionHeaderView.self
    }
}

/**
 *
 *
 */
public class BaseCollectionFooterModel : BaseCollectionReusableModel {
    
    ///
    override var identifier: String {
        return "base_collection_footer"
    }
    
    ///
    override var viewClass: AnyClass? {
        return BaseCollectionFooterView.self
    }
}

