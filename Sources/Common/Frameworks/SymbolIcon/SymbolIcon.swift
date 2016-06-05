//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public struct SymbolIcon {

    private let character: Character

    public init(character: Character) {
        self.character = character
    }
}

#if os(iOS)
import UIKit

public extension SymbolIcon {

    func attributedStringOf(size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"
        let font = UIFont.fontWith(name: name, size: size, fromFile: file)

        return NSMutableAttributedString(string: "\(character)").then { $0.addFont(font) }
    }

    func bitmapImageOf(size: CGFloat) -> UIImage? {
        let label = UILabel.dummyInstance.then {
            let string = attributedStringOf(size)
            $0.attributedText = string
            $0.sizeToFit()
        }

        return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
    }
}
#elseif os(OSX)
import AppKit

public extension SymbolIcon {

    func attributedStringOf(size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"
        let font = NSFont.fontWith(name: name, size: size, fromFile: file)

        return NSMutableAttributedString(string: "\(character)").then { $0.addFont(font) }
    }
}
#endif