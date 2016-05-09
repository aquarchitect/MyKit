//
//  _RuntimeFontLoadable.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/13/16.
//  
//

private func registerFont(from file: String, ofBundle bundle: NSBundle) throws {
    let ext = "ttf"

    let _file = !file.hasSuffix(ext) ? file : {
        let endIndex = file.endIndex
        let startIndex = file.endIndex.advancedBy(-ext.characters.count)
        return file[startIndex..<endIndex]
        }()


    // get file url
    guard let url = bundle.URLForResource(file, withExtension: ext)
        else { throw CommonError.FailedToLocateFile(_file) }

    let data = NSData(contentsOfURL: url)
    let provider = CGDataProviderCreateWithCFData(data)

    // register font
    guard let font = CGFontCreateWithDataProvider(provider)
        where CTFontManagerRegisterGraphicsFont(font, nil) else {
            enum Exception: ErrorType { case FailedToRegisterFont(String) }
            throw Exception.FailedToRegisterFont(_file)
    }
}

public protocol _RuntimeFontLoadable: class {

    init?(name: String, size: CGFloat)
}

extension _RuntimeFontLoadable {

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
extension UIFont: _RuntimeFontLoadable {}
#elseif os(OSX)
extension NSFont: _RuntimeFontLoadable {}
#endif