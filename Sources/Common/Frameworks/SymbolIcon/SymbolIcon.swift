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
        return NSMutableAttributedString(string: "\(character)").then {
            $0.addFont(.getFont(name: "Ionicons", size: size, fromFile: "SymbolIcon"))
        }
    }
}
