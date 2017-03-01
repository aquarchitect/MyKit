/*
 * UndoManager+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension UndoManager {

    var undoMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Undo"
            $0.keyEquivalent = "z"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(undo)
        }
    }

    var redoMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Redo"
            $0.keyEquivalent = "z"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.target = self
            $0.action = #selector(redo)
        }
    }
}
