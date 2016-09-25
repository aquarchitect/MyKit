/*
 * _FontLoading.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
    static func font(withName name: String, size: CGFloat, fromFile file: String) -> Self? {
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
