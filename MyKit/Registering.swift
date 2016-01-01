//
//  Loading.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

func registerFont(name: String) throws {
    guard let bundle = NSBundle.defaultBundle(),
        url = bundle.URLForResource(name, withExtension: "ttf")
        else { throw FileError.InvalidResourcePath }

    let data = NSData(contentsOfURL: url)
    let provider = CGDataProviderCreateWithCFData(data)

    guard let font = CGFontCreateWithDataProvider(provider)
        where CTFontManagerRegisterGraphicsFont(font, nil)
        else { throw FileError.UnableToDescryptTheFile }
}