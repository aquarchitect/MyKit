//
//  Loading.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

/**
    Register custom font from ttf into system.
    
    - Parameters:
        - name: The name of ttf file with extension.
        
    - Throws: Results into `FileError`.
        - __InvalidResourcePath__
        - __UnableToDescryptTheFile__
*/
func registerFont(name: String) throws {
    // check extension
    assert(!name.hasSuffix(".ttf"), "Only support file name without extension.")

    // get file url
    guard let bundle = NSBundle.defaultBundle(),
        url = bundle.URLForResource(name, withExtension: "ttf")
        else { throw FileError.InvalidResourcePath }

    let data = NSData(contentsOfURL: url)
    let provider = CGDataProviderCreateWithCFData(data)

    // register font
    guard let font = CGFontCreateWithDataProvider(provider)
        where CTFontManagerRegisterGraphicsFont(font, nil)
        else { throw FileError.UnableToDecryptTheFile }
}