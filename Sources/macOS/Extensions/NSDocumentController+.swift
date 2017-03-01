/*
 * NSDocumentController+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSDocumentController {

    var newDocumentMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "New"
            $0.keyEquivalent = "n"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(newDocument(_:))
        }
    }

    var openDocumentMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Open..."
            $0.keyEquivalent = "o"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(openDocument(_:))
        }
    }

    var clearRecentDocumentsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Clear Menu"
            $0.target = self
            $0.action = #selector(clearRecentDocuments(_:))
        }
    }
}
