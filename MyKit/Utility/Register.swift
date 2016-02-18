//
//  Loading.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

/**

Register custom font from ttf into system.
    
- parameter name: The name of ttf file with extension.
        
- throws: Results into `FileError`.
    - InvalidResourcePath
    - UnableToDescryptTheFile

*/
func register(font file: String) throws {
    enum Error: ErrorType {

        case FailedToLocate(String)
        case FailedToRegister(String)
    }

    let ext = "ttf"
    let _file = file.hasSuffix(ext) ? file : (file + ".\(ext)")

    // get file url
    guard let bundle = NSBundle.defaultBundle(),
        url = bundle.URLForResource(_file, withExtension: "ttf")
        else { throw Error.FailedToLocate(file) }

    let data = NSData(contentsOfURL: url)
    let provider = CGDataProviderCreateWithCFData(data)

    // register font
    guard let font = CGFontCreateWithDataProvider(provider)
        where CTFontManagerRegisterGraphicsFont(font, nil)
        else { throw Error.FailedToRegister(file) }
}