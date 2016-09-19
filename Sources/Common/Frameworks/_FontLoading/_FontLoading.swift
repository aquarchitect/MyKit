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

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

private func registerFont(from file: String, ofBundle bundle: NSBundle) throws {
    let ext = "ttf"

    let _file = !file.hasSuffix(ext) ? file : {
        let endIndex = file.endIndex
        let startIndex = file.endIndex.advancedBy(-ext.characters.count)
        return file[startIndex..<endIndex]
        }()


    // get file url
    guard let url = bundle.URLForResource(file, withExtension: ext),
        let data = NSData(contentsOfURL: url),
        let provider = CGDataProviderCreateWithCFData(data)
        else { throw FileIOError.UnableToOpen(file: _file) }

    let font = CGFontCreateWithDataProvider(provider)
    // register font
    guard CTFontManagerRegisterGraphicsFont(font, nil) else {
        enum Exception: ErrorType { case FailedToRegisterFont(String) }
        throw Exception.FailedToRegisterFont(_file)
    }
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
    static func fontWith(name name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            guard let bundle = NSBundle.defaultBundle else { return nil }

            do { try registerFont(from: file, ofBundle: bundle) }
            catch { print(error) }

            return Self(name: name, size: size)
        }()
    }
}

#if os(iOS)
extension UIFont: _FontLoading {}
#elseif os(OSX)
extension NSFont: _FontLoading {}
#endif
