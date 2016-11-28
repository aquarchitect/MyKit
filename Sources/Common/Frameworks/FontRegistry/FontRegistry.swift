/*
 * FontRegistry.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

/*
 * Public scope lets the test module to recognize the protocol;
 * but it's designed only for internal usage.
 */
public protocol FontRegistry: class {

    init?(name: String, size: CGFloat)
}

extension FontRegistry {

    private static func registerFont(from file: String, of bundle: Bundle) {
        _ = bundle
            .url(forResource: file, withExtension: "ttf")
            .flatMap(NSData.init(contentsOf:))
            .flatMap { CGDataProvider(data: $0) }
            .map(CGFont.init)
            .map { CTFontManagerRegisterGraphicsFont($0, nil) }
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
extension UIFont: FontRegistry {}
#elseif os(OSX)
import AppKit.NSFont
extension NSFont: FontRegistry {}
#endif
