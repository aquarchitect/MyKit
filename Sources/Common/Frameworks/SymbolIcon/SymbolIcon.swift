/*
 * SymbolIcon.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation.NSAttributedString
import CoreGraphics

public struct SymbolIcon {

#if swift(>=3.0)
    fileprivate let character: Character
#else
    private let character: Character
#endif

    public init(_ character: Character) {
        self.character = character
    }
}

public extension SymbolIcon {

#if swift(>=3.0)
    func attributedString(ofSize size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"
        
        return NSMutableAttributedString(string: "\(character)").then {
            $0.addFont(.getFont(name: name, size: size, fromFile: file))
        }
    }
#else
    func attributedStringOfSize(size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"

        return NSMutableAttributedString(string: "\(character)").then {
            $0.addFont(.getFont(name: name, size: size, fromFile: file))
        }
    }
#endif
}
