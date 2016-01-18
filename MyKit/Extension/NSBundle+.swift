//
//  NSBundle+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

extension NSBundle {

    class func defaultBundle() -> NSBundle? {
        #if os(iOS)
            let platform = "iOS"
        #elseif os(OSX)
            let platform = "OSX"
        #endif

        let identifier = "HaiNguyen.MyKit\(platform)"
        return NSBundle(identifier: identifier)
    }
}