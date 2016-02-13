//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public struct SymbolIcon {

    public static func attributedStringOf(character: Character, size: CGFloat) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: String(character))
        let arguments = (name: "IonIcons", size: size)

        let register: AnyObject? -> Void = {
            guard $0 == nil else { return }
            do { try registerFont("IonIcons")
            } catch { print(error) }
        }

        #if os(iOS)
            register(UIFont(arguments))
            string.addFontAttribute(UIFont(arguments)!, range: nil)

        #elseif os(OSX)
            register(NSFont(arguments))
            string.addFontAttribute(NSFont(arguments)!, range: nil)

        #endif
        
        return string
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