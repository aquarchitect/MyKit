//
// NSTextField+.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSTextField {

    static var staticLabel: NSTextField {
        return NSTextField().then {
            $0.isBezeled = false
            $0.isEditable = false
            $0.isSelectable = false
            $0.drawsBackground = false
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    var fieldEditor: NSTextView? {
        return self.cell.flatMap {
            $0.fieldEditor(for: self)
        }
    }
}
