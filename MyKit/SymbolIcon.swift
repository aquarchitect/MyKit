//
//  SymbolIcon.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/31/15.
//
//

public enum SymbolIcon: Character {

    case Cross = "\u{F03A}"
    case Check = "\u{F081}"

    public func stringWithOption(size: CGFloat) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: "\(self.rawValue)")
        let arguments = (name: "octicons", size: size)

        let register: AnyObject? -> Void = {
            guard $0 == nil else { return }
            do { try registerFont("Octicons")
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
}