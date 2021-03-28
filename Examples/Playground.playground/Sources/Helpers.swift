import Foundation
import UIKit

extension NSAttributedString: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        //self.string
        let layoutManager = CustomLayoutManager()
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        textContainer.heightTracksTextView = true
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)

        let v = UITextView(frame: .init(x: 0, y: 0, width: 300, height: 400), textContainer: textContainer)
        v.backgroundColor = .white
        v.attributedText = self
        let s = v.sizeThatFits(.init(width: 350, height: 1000))
        v.frame = .init(origin: .zero, size: s)

        layoutManager.textContainerOriginOffset = CGSize(
            width: v.textContainerInset.left,
            height: v.textContainerInset.top
        )
        layoutManager.invalidateDisplay(forCharacterRange: NSRange(location: 0, length: v.attributedText.length))
        return v
    }
}

// Implementation based on this article https://augmentedcode.io/2019/11/10/adding-custom-attribute-to-nsattributedstring-on-ios/
extension NSAttributedString.Key {
    public static let fillTheGap = NSAttributedString.Key("fillTheGap")
}

class CustomLayoutManager: NSLayoutManager {
    var textContainerOriginOffset: CGSize = .zero

    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        textStorage?.enumerateAttribute(
            .fillTheGap,
            in: characterRange,
            options: [],
            using: { (value, subrange, _) in
                guard let token = value as? String, !token.isEmpty else { return }
                let tokenGlypeRange = glyphRange(forCharacterRange: subrange, actualCharacterRange: nil)
                drawToken(forGlyphRange: tokenGlypeRange)
            }
        )
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    }

    private func drawToken(forGlyphRange tokenGlypeRange: NSRange) {
        guard let textContainer = textContainer(
            forGlyphAt: tokenGlypeRange.location,
            effectiveRange: nil
        ) else { return }
        let withinRange = NSRange(location: NSNotFound, length: 0)
        enumerateEnclosingRects(
            forGlyphRange: tokenGlypeRange,
            withinSelectedGlyphRange: withinRange,
            in: textContainer
        ) { (rect, _) in
            let tokenRect = rect.offsetBy(
                dx: self.textContainerOriginOffset.width,
                dy: self.textContainerOriginOffset.height
            )
            UIColor(hue: 175.0/360.0, saturation: 0.24, brightness: 0.88, alpha: 1).setFill()
            UIBezierPath(roundedRect: tokenRect, cornerRadius: 4).fill()
        }
    }
}
