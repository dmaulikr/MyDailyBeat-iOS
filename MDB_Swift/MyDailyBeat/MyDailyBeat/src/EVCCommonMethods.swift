
//
//  EVCCommonMethods.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import UIKit
class EVCCommonMethods: NSObject {
    
    class func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newSize.width), height: CGFloat(newSize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    class func barButtonSystemItem(_ item: UIBarButtonSystemItem, withText title: String) -> UIButton {
        let tempBarButton = UIBarButtonItem(barButtonSystemItem: item, target: nil, action: nil)
        let img: UIImage? = tempBarButton.image
        let btn = UIButton()
        btn.setBackgroundImage(img, for: .normal)
        btn.setTitle(title, for: .normal)
        return btn
    }

    class func image(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let rPath = UIBezierPath(rect: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(size.width), height: CGFloat(size.height)))
        color.setFill()
        rPath.fill()
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    class func fixOrientation(for inputImage: UIImage) -> UIImage {
        
        // No-op if the orientation is already correct
        guard inputImage.imageOrientation != .up else {
            return inputImage
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Int(inputImage.size.width), height: Int(inputImage.size.height)))
            // We need to calculate the proper transformation to make the image upright.
            // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        switch inputImage.imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: inputImage.size.width, y: inputImage.size.height)
                transform = transform.rotated(by: .pi)
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: inputImage.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(M_PI_2))
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: inputImage.size.height)
                transform = transform.rotated(by: -(CGFloat)(M_PI_2))
            case .up, .upMirrored:
                break
        }

        switch inputImage.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: inputImage.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: inputImage.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .up, .down, .left, .right:
                break
        }
        
        return renderer.image(actions: { (context) in
            let ctx = context.cgContext
            ctx.concatenate(transform)
            switch inputImage.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                // Grr...
                let rect = CGRect(x: 0, y: 0, width: inputImage.size.height, height: inputImage.size.width)
                ctx.draw(inputImage.cgImage!, in: rect, byTiling: false)
            default:
                let rect = CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height)
                ctx.draw(inputImage.cgImage!, in: rect, byTiling: false)
            }
        })
    }

    class func meters(forRadius miles: Double) -> Double {
        return miles * 1609.34
    }

    class func miles(forRadius meters: Double) -> Double {
        return meters / 1609.34
    }
}
