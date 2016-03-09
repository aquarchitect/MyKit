//
//  Loading.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

private enum Exception: ErrorType {

    case FailedToLocate(String)
    case FailedToRegister(String)
}

/**
Register custom font from .ttf file into system.
    
- parameter name: The name of ttf file with extension.
        
- throws: Results into `FileError`.
    - InvalidResourcePath
    - UnableToDescryptTheFile
*/
func register(font file: String) throws {
    let ext = "ttf"

    let _file = !file.hasSuffix(ext) ? file : {
        let endIndex = file.endIndex
        let startIndex = file.endIndex.advancedBy(-ext.characters.count)
        return file[startIndex..<endIndex]
    }()

    // get file url
    guard let bundle = NSBundle.defaultBundle(),
        url = bundle.URLForResource(_file, withExtension: "ttf")
        else { throw Exception.FailedToLocate(file) }

    let data = NSData(contentsOfURL: url)
    let provider = CGDataProviderCreateWithCFData(data)

    // register font
    guard let font = CGFontCreateWithDataProvider(provider)
        where CTFontManagerRegisterGraphicsFont(font, nil)
        else { throw Exception.FailedToRegister(file) }
}