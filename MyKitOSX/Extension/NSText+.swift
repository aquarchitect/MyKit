//
//  NSText+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/12/16.
//  
//

public extension NSText {

    public static var measureingInstance: NSText {
        struct Cache { static let text = NSText() }
        return Cache.text
    }
}