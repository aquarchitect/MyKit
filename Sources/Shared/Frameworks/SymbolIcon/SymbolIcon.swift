// 
// SymbolIcon.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation
import CoreGraphics

public struct SymbolIcon {

    // MARK: Properties

    fileprivate let character: Character

    // MARK: Initialization

    public init(_ character: Character) {
        self.character = character
    }
}

public extension SymbolIcon {

    func attributedString(ofSize size: CGFloat) -> NSMutableAttributedString {
#if os(iOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-iOS")
#elseif os(macOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-macOS")
#endif
        let name = "Ionicons", file = "SymbolIcon", ext = "ttf"

        if let font = Font.customFont(name: name, size: size, fromFile: file, withExtension: ext, in: bundle) {
            return NSMutableAttributedString(string: "\(character)")
                .then({ $0.addFont(font) })
        } else {
            fatalError("Unable to find \(name) font in \(file).\(ext)!")
        }
    }
}
