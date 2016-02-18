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
            let callback: Void throws -> UIFont? = {
                try UIFont(arguments) ?? {
                    try register(font: "IonIcons")
                    return UIFont(arguments)
                }()
            }
        #elseif os(OSX)
            let callback: Void throws -> NSFont? = {
                try NSFont(arguments) ?? {
                    try register(font: "IonIcons")
                    return NSFont(arguments)
                }()
            }
        #endif
        
        return NSMutableAttributedString(string: "\(character)").then { string in
            Promise(callback).succeed { string.addFontAttribute($0) }
        }
    }

    #if os(iOS)
        public static func imageOf(character: Character, size: CGFloat) -> UIImage? {
            let label = UILabel.measuringInstance.then {
                let string = SymbolIcon.attributedStringOf(character, size: size)
                $0.attributedText = string
                $0.sizeToFit()
            }

            return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
        }
    #endif
}