//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public struct SymbolIcon {

    public static func attributedStringOf(character: Character, size: CGFloat) -> NSMutableAttributedString {
        let arguments = (name: "IonIcons", size: size)

        #if os(iOS)
            let font: UIFont? = UIFont(arguments) ?? {
                try! register(font: "SymbolIcon")
                return UIFont(arguments)
            }()
        #elseif os(OSX)
            let font: NSFont? = NSFont(arguments) ?? {
                try! register(font: "SymbolIcon")
                return NSFont(arguments)
            }()
        #endif
        
        return NSMutableAttributedString(string: "\(character)").then { $0.addFontAttribute(font) }
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