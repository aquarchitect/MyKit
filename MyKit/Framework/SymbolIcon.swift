//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public enum SymbolIcon: Character {

    case LinedCross = "\u{F2D7}"
    case LinedCheck = "\u{F383}"

    case CircledCross = "\u{F406}"
    case CircledCheck = "\u{F3FF}"

    case StandardSetting = "\u{F13E}"

    public func attributedStringIn(size: CGFloat) -> NSMutableAttributedString {
        return SymbolIcon.attributedStringWith(self.rawValue, size: size)
    }
}

public extension SymbolIcon {

    public static func attributedStringWith(character: Character, size: CGFloat) -> NSMutableAttributedString {
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
        public static func imageWithCharacter(character: Character, size: CGFloat) -> UIImage? {
            let label = UILabel.sharedInstance.setup {
                $0.attributedText = SymbolIcon.attributedStringWith(character, size: size)
                $0.sizeToFit()
            }

            return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
        }
    #endif
}