//
//  BaseCollectionModels.swift
//  Pods-PVDBaseMVC_Tests
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation
import PVDSwiftAddOns

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
        return "base_collection_cell"
    }
    
    ///
    open var viewClass: AnyClass? {
        return BaseCollectionCellView.self
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
        self.size = size
    }
}

/**
 */
open class BaseCollectionTextCellModel: BaseCollectionCellModel {
    
    ///
    override open var cellIdentifier: String {
        return "base_collection_text_cell"
    }
    
    ///
    override open var viewClass: AnyClass? {
        return BaseCollectionTextCellView.self
    }
    
    open var text: String?
    open var textDescriptor: TextDescriptor
    open var insets: UIEdgeInsets
    
    /**
     */
    public init(text: String?, textDescriptor: TextDescriptor, size: CGSize, insets: UIEdgeInsets = .zero, shouldWrap: Bool = true) {
        self.text = text
        self.textDescriptor = textDescriptor
        self.insets = insets
        if shouldWrap && text != nil {
            var size = size
            size.height = text!.height(withConstrainedWidth: size.width, font: textDescriptor.font)
            size.height += insets.top + insets.bottom
            super.init(size: size)
        }
        else {
            super.init(size: size)
        }
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

