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
    
    open var text: NSAttributedString?
    open var textDescriptor: TextDescriptor
    open var insets: UIEdgeInsets
    open var backgroundColor: UIColor?
    
    /**
     */
    public init(text: String?, textDescriptor: TextDescriptor, size: CGSize, backgroundColor: UIColor? = nil, insets: UIEdgeInsets = .zero, shouldWrap: Bool = true) {
        self.text = text != nil ? NSAttributedString(string: text!) : nil
        self.textDescriptor = textDescriptor
        self.insets = insets
        self.backgroundColor = backgroundColor
        if shouldWrap && text != nil {
            var size = size
            size.height = text!.height(withConstrainedWidth: size.width - insets.left - insets.right, font: textDescriptor.font)
            size.height += insets.top + insets.bottom
            super.init(size: size)
        }
        else {
            super.init(size: size)
        }
    }
    
    /**
     */
    public init(text: NSAttributedString?, textDescriptor: TextDescriptor, size: CGSize, insets: UIEdgeInsets = .zero, shouldWrap: Bool = true) {
        self.text = text
        self.textDescriptor = textDescriptor
        self.insets = insets
        guard let text = text, shouldWrap else {
            super.init(size: size)
            return
        }
        let string = text.string
        let attrString = NSMutableAttributedString.init(attributedString: text)
        attrString.addAttributes([
                .font: textDescriptor.font,
                .foregroundColor: textDescriptor.color],
            range: NSRange(location: 0, length: string.count))
        var height = attrString.height(withConstrainedWidth: size.width - insets.left - insets.right)
        height += insets.top + insets.bottom
        super.init(size: CGSize(width: size.width, height: height))
    }
}

/**
 *
 *
 */
open class BaseCellWithCollectionModel : BaseCollectionCellModel {
    
    ///
    override open var cellIdentifier: String {
        return "base_cell_with_collection"
    }
    
    ///
    override open var viewClass: AnyClass? {
        return BaseCellWithCollectionView.self
    }
}

/**
 *
 *
 */
open class ImageCellModel: BaseCollectionCellModel {
    
    ///
    override open var cellIdentifier: String {
        return "image_cell"
    }
    
    ///
    override open var viewClass: AnyClass? {
        return ImageCellView.self
    }
    
    ///
    open var image: UIImage?
    open var imageURL: URL?
    open var contentMode: UIView.ContentMode = .scaleAspectFill
    open var backgroundColor: UIColor?
    open var imageSize: CGSize?
    
    /**
     */
    public init(url: URL? = nil, image: UIImage? = nil, imageSize: CGSize? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, backgroundColor: UIColor? = nil, size: CGSize) {
        self.imageURL = url
        self.image = image
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.imageSize = imageSize
        super.init(size: size)
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



