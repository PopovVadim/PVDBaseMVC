//
//  UIImage.swift
//  Pods-PVDSwiftAddOns_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation

/**
 *
 *
 */
public extension UIImage {
    
    /**
     */
    func rotatedImage() -> UIImage {
        let orientation = self.detectOrientation()
        switch orientation {
        case .right:
            return imageRotatedByDegrees(degrees: 90)
        case .left:
            return imageRotatedByDegrees(degrees: -90)
        case .down:
            return imageRotatedByDegrees(degrees: 180)
        case .up:
            return imageRotatedByDegrees(degrees: 180)
        default:
            return self
        }
    }
    
    /**
     */
    func detectOrientation() -> UIImage.Orientation{
        var newOrientation = UIImage.Orientation.up
        switch (self.imageOrientation)
        {
        case .up:
            newOrientation = .up;
            break;
        case .down:
            newOrientation = .down;
            break;
        case .left:
            newOrientation = .left;
            break;
        case .right:
            newOrientation = .right;
            break;
        case .upMirrored:
            newOrientation = .upMirrored;
            break;
        case .downMirrored:
            newOrientation = .downMirrored;
            break;
        case .leftMirrored:
            newOrientation = .leftMirrored;
            break;
        case .rightMirrored:
            newOrientation = .rightMirrored;
            break;
        }
        return newOrientation;
    }
    
    /**
     */
    func imageRotatedByDegrees(degrees: CGFloat, flip: Bool = false) -> UIImage {
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degrees.degreesToRadians)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        
        //   // Rotate the image context
        bitmap!.rotate(by: degrees.degreesToRadians)
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
     */
    func cropToSquare() -> UIImage? {
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
    /**
     */
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
