//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public struct SymbolIcon {

    public static func attributedStringOf(character: Character, size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"

        #if os(iOS)
            let font = UIFont.fontWith(name: name, size: size, fromFile: file)
        #elseif os(OSX)
            let font = NSFont.fontWith(name: name, size: size, fromFile: file)
        #endif

        return NSMutableAttributedString(string: "\(character)").then { $0.addFont(font) }
    }

    #if os(iOS)
        public static func imageOf(character: Character, size: CGFloat) -> UIImage? {
            let label = UILabel.dummyInstance.then {
                let string = SymbolIcon.attributedStringOf(character, size: size)
                $0.attributedText = string
                $0.sizeToFit()
            }

            return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
        }
    #endif
}