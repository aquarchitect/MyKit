//
//  CustomFont.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/13/16.
//  
//

private enum Exception: ErrorType {

    case FailedToRegister(String)
}

public protocol CustomFont: class {

    init?(name: String, size: CGFloat)
}

extension CustomFont {

    static func registerFontFrom(file: String, ofBundle bundle: NSBundle) throws {
        let ext = "ttf"

        let _file = !file.hasSuffix(ext) ? file : {
            let endIndex = file.endIndex
            let startIndex = file.endIndex.advancedBy(-ext.characters.count)
            return file[startIndex..<endIndex]
            }()

        // get file url
        guard let url = bundle.URLForResource(_file, withExtension: "ttf")
            else { throw CommonError.FailedToLocate(file: _file) }

        let data = NSData(contentsOfURL: url)
        let provider = CGDataProviderCreateWithCFData(data)

        // register font
        guard let font = CGFontCreateWithDataProvider(provider)
            where CTFontManagerRegisterGraphicsFont(font, nil)
            else { throw Exception.FailedToRegister(_file) }
    }

    /// Return a font object
    static func fontWith(name name: String, size: CGFloat, fromFile file: String, ofBundle bundle: NSBundle) -> Self? {
        return Self(name: name, size: size) ?? {
            _ = try? registerFontFrom(file, ofBundle: bundle)
            return Self(name: name, size: size)
        }()
    }

    /// Return a font object from default bundle
    static func fontWith(name name: String, size: CGFloat, fromFile file: String) -> Self? {
        return Self(name: name, size: size) ?? {
            _ = try? NSBundle.defaultBundle?.then {
                try registerFontFrom(file, ofBundle: $0)
            }
            return Self(name: name, size: size)
        }()
    }
}

#if os(iOS)
    extension UIFont: CustomFont {}
#elseif os(OSX)
    extension NSFont: CustomFont {}
#endif