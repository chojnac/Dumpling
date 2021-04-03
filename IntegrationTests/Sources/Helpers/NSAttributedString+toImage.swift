//
//  NSAttributedString+toImage.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 29/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit

// render attribnuted string into image with scale ratio = 1
extension NSAttributedString {
    public func toImage(width: CGFloat) -> UIImage? {

        let rect = boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let size = CGSize(width: width, height: rect.size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        self.draw(in: CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return image
    }
}
#elseif canImport(AppKit)
import AppKit

extension NSAttributedString {
    public func toImage(width: CGFloat) -> NSImage? {

        let framesetter = CTFramesetterCreateWithAttributedString(self)
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRange(),
            nil,
            CGSize(width: width, height: .greatestFiniteMagnitude),
            nil
        )

        let size = CGSize(width: width, height: textSize.height)

        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSColorSpaceName.calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )
        rep?.size = size
        let context = NSGraphicsContext(bitmapImageRep: rep!)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        context?.cgContext.setFillColor(NSColor.white.cgColor)
        context?.cgContext.fill(CGRect(origin: .zero, size: size))

        self.draw(in: NSRect(origin: .zero, size: size))
        NSGraphicsContext.restoreGraphicsState()
        
        let image = NSImage(size: size)
        image.addRepresentation(rep!)
        return image
//        let image = NSImage(size: size, flipped: false) { dstRect -> Bool in
//            let context = NSGraphicsContext.current?.cgContext
//            context?.setFillColor(NSColor.white.cgColor)
//            context?.fill(CGRect(origin: .zero, size: size))
//            self.draw(in: dstRect)
//            return true
//        }
//        return image
    }
}
#endif
