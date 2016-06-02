//
//  NSBundle+.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/1/16.
//
//

import Foundation

extension NSBundle {

    static var defaultBundle: NSBundle? {
#if os(iOS)
        let platform = "iOS"
#elseif os(OSX)
        let platform = "OSX"
#endif

        return NSBundle(identifier: "HaiNguyen.MyKit-\(platform)")
    }
}