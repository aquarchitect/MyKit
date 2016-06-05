//
//  NSTableView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/22/15.
//  
//

import Cocoa

public extension NSTableView {

    public func addDoubleAction(action: NSControl -> Void) {
        self.addActionForProperty(action, property: "doubleAction")
    }
}
