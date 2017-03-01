/*
 * NSResponder+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSResponder {

    var centerSelectionInVisibleAreaMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Jump to Selection"
            $0.keyEquivalent = "j"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(centerSelectionInVisibleArea(_:))
        }
    }
}

public extension NSResponder {

    var makeBaseWritingDirectionNaturalMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tDefault"
            $0.target = self
            $0.action = #selector(makeBaseWritingDirectionNatural(_:))
        }
    }

    var makeBaseWritingDirectionLeftToRightMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tLeft to Right"
            $0.target = self
            $0.action = #selector(makeBaseWritingDirectionLeftToRight(_:))
        }
    }

    var makeBaseWritingDirectionRightToLeftMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tRight to Left"
            $0.target = self
            $0.action = #selector(makeBaseWritingDirectionRightToLeft(_:))
        }
    }

    var makeTextWritingDirectionNaturalMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tDefault"
            $0.target = self
            $0.action = #selector(makeTextWritingDirectionNatural(_:))
        }
    }

    var makeTextWritingDirectionLeftToRightMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tLeft to Right"
            $0.target = self
            $0.action = #selector(makeTextWritingDirectionLeftToRight(_:))
        }
    }

    var makeTextWritingDirectionRightToLeftMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tRight to Left"
            $0.target = self
            $0.action = #selector(makeTextWritingDirectionRightToLeft(_:))
        }
    }

    var writingDirectionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Writing Direction"
            $0.submenu = NSMenu().then {
                [
                    NSMenuItem(title: "Paragraph", action: nil, keyEquivalent: ""),
                    makeBaseWritingDirectionNaturalMenuItem,
                    makeBaseWritingDirectionLeftToRightMenuItem,
                    makeBaseWritingDirectionRightToLeftMenuItem,
                    .separator(),
                    NSMenuItem(title: "Selection", action: nil, keyEquivalent: ""),
                    makeTextWritingDirectionNaturalMenuItem,
                    makeTextWritingDirectionLeftToRightMenuItem,
                    makeTextWritingDirectionRightToLeftMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}
