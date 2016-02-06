//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public enum SymbolIcon {

    public enum Style1 { case Lined, Circled }
    public enum Style2 { case Stroked, Filled }

    case Cross(Style1)
    case Check(Style1)
    case Heart(Style2)
    case Configuration

    public var character: Character {
        switch self {

        case .Cross(let style):
            switch style {

            case .Lined: return "\u{F2D7}"
            case .Circled: return "\u{F406}"
            }
        case .Check(let style):
            switch style {

            case .Lined: return "\u{F383}"
            case .Circled: return "\u{F3FF}"
            }
        case .Heart(let style):
            switch style {

            case .Stroked: return "\u{F442}"
            case .Filled: return "\u{F443}"
            }
        case .Configuration: return "\u{F13E}"
        }
    }

    #if os(iOS)

    public func imageWith(size: CGFloat) -> UIImage? {
        return SymbolIcon.imageWith(self.character, size: size)
    }

    #endif


    public func attributedStringWith(size: CGFloat) -> NSMutableAttributedString {
        return SymbolIcon.attributedStringWith(self.character, size: size)
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
    public static func imageWith(character: Character, size: CGFloat) -> UIImage? {
        let label = UILabel.sharedInstance.setup {
            $0.attributedText = SymbolIcon.attributedStringWith(character, size: size)
            $0.sizeToFit()
        }

        return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
    }
    #endif
}