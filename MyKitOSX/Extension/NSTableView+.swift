//
//  NSTableView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/22/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension NSTableView {

    public func addDoubleAction(action: NSControl -> Void) {
        self.addActionForProperty(action, property: "doubleAction")
    }
}
