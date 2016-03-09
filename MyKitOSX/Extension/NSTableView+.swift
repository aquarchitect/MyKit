//
//  NSTableView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/22/15.
//  
//

public extension NSTableView {

    public func addDoubleAction(action: NSControl -> Void) {
        self.addActionForProperty(action, property: "doubleAction")
    }
}
