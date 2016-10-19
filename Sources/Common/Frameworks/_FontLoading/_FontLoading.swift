/*
 * _FontLoading.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
func registerFont(from file: String, of bundle: Bundle) throws {
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
#else
func registerFontFromFile(file: String, ofBundle bundle: NSBundle) throws {
    let ext = "ttf"

    let _file = !file.hasSuffix(ext) ? file : {
        let endIndex = file.endIndex
        let startIndex = endIndex.advancedBy(-ext.characters.count)
        return file[startIndex..<endIndex]
        }()

    enum Exception: ErrorType {

        case unableToOpen(file: String)
        case failedToRegisterFont(String)
    }



    // get file url
    guard let url = bundle.URLForResource(file, withExtension: ext),
        let provider = (NSData(contentsOfURL: url).flatMap { CGDataProviderCreateWithCFData($0) })
        else { throw Exception.unableToOpen(file: _file) }

    // register font
    let font = CGFontCreateWithDataProvider(provider)
    guard CTFontManagerRegisterGraphicsFont(font, nil)
        else { throw Exception.failedToRegisterFont(_file) }
}
#endif

/*
 * Public scope lets the test module to recognize the protocol;
 * but it's designed only for internal usage.
 */
public protocol _FontLoading: class {

    init?(name: String, size: CGFloat)
}

extension _FontLoading {

    /// Return a font object from default bundle
#if swift(>=3.0)
    static func getFont(name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            guard let bundle = Bundle.default else { return nil }

            do {
                try registerFont(from: file, of: bundle)
            } catch {
                print(error)
            }

            return Self(name: name, size: size)
        }()
    }
#else
    static func getFont(name name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            guard let bundle = NSBundle.defaultBundle() else { return nil }

            do {
                try registerFontFromFile(file, ofBundle: bundle)
            } catch {
                print(error)
            }

            return Self(name: name, size: size)
        }()
    }
#endif
}

#if os(iOS)
import UIKit.UIFont
extension UIFont: _FontLoading {}
#elseif os(OSX)
import AppKit.NSFont
extension NSFont: _FontLoading {}
#endif
