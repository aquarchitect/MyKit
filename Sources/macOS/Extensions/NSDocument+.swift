/*
 * NSDocument+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSDocument {

    var saveMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Save..."
            $0.keyEquivalent = "s"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(save(_:))
        }
    }

    var saveAsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Save As..."
            $0.keyEquivalent = "s"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.target = self
            $0.action = #selector(saveAs(_:))
        }
    }

    var revertToSavedMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Revert to Saved"
            $0.keyEquivalent = "r"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(revertToSaved(_:))
        }
    }
}
