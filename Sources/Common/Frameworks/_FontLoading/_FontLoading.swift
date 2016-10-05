/*
 * _FontLoading.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

private func registerFont(from file: String, of bundle: Bundle) throws {
    let ext = "ttf"

    let _file = !file.hasSuffix(ext) ? file : {
        let endIndex = file.endIndex
        let startIndex = file.index(file.endIndex, offsetBy: -ext.characters.count)
        return file[startIndex..<endIndex]
        }()

    enum Exception: Error {

        case unableToOpen(file: String)
        case failedToRegisterFont(String)
    }

    // get file url
    guard let url = bundle.url(forResource: file, withExtension: ext),
        let provider = (NSData(contentsOf: url).flatMap { CGDataProvider(data: $0) })
        else { throw Exception.unableToOpen(file: _file) }

    // register font
    guard CTFontManagerRegisterGraphicsFont(.init(provider), nil)
        else { throw Exception.failedToRegisterFont(_file) }
}

/*
 * Public scope lets the test module to recognize the protocol;
 * but it's designed only for internal usage.
 */
public protocol _FontLoading: class {

    init?(name: String, size: CGFloat)
}

extension _FontLoading {

    /// Return a font object from default bundle
    static func font(name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            guard let bundle = Bundle.`default` else { return nil }

            do { try registerFont(from: file, of: bundle) }
            catch { print(error) }

            return Self(name: name, size: size)
        }()
    }
}

#if os(iOS)
import UIKit.UIFont
extension UIFont: _FontLoading {}
#elseif os(macOS)
import AppKit.NSFont
extension NSFont: _FontLoading {}
#endif
