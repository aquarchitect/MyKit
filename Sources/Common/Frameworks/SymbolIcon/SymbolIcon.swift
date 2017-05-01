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

    fileprivate let character: Character

    public init(_ character: Character) {
        self.character = character
    }
}

public extension SymbolIcon {

    func attributedString(ofSize size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"
        
        return NSMutableAttributedString(string: "\(character)").then {
            $0.addFont(.getFont(name: name, size: size, fromFile: file))
        }
    }
}
