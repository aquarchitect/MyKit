// 
// FontRegistering.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

/// This class is for register font in a framework
/// 
/// - Warning: even though the protocol marks as Public
/// for unit testing, it's designed for internal usage only.
public protocol FontRegistering: class {

    init?(name: String, size: CGFloat)
}

extension FontRegistering {

    private static func registerFont(from file: String, of bundle: Bundle) {
        _ = bundle
            .url(forResource: file, withExtension: "ttf")
            .flatMap(NSData.init(contentsOf:))
            .flatMap({ CGDataProvider(data: $0) })
            .map(CGFont.init)
            .map({ CTFontManagerRegisterGraphicsFont($0, nil) })
    }

    /// Return a font object from default bundle
    static func getFont(name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            guard let bundle = Bundle.default else { return nil }
            registerFont(from: file, of: bundle)

            return Self(name: name, size: size)
        }()
    }
}

#if os(iOS)
import UIKit.UIFont
extension UIFont: FontRegistering {}
#elseif os(OSX)
import AppKit.NSFont
extension NSFont: FontRegistering {}
#endif
