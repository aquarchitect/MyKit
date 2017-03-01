/*
 * NSText+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSText {

    var cutMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Cut"
            $0.keyEquivalent = "x"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(cut(_:))
        }
    }

    var copyMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(copy(_:))
        }
    }

    var pasteMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(paste(_:))
        }
    }

    var deleteMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Delete"
            $0.target = self
            $0.action = #selector(delete(_:))
        }
    }

    var selectAllMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Select All"
            $0.keyEquivalent = "a"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(selectAll(_:))
        }
    }
}

public extension NSText {

    var showGuessPanelMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Spelling and Grammar"
            $0.keyEquivalent = ":"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(showGuessPanel(_:))
        }
    }

    var checkSpellingMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Document Now"
            $0.keyEquivalent = ";"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(checkSpelling(_:))
        }
    }
}

public extension NSText {

    var underlineMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Underline"
            $0.keyEquivalent = "u"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(underline(_:))
        }
    }
}

public extension NSText {

    var copyFontMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy Style"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.target = self
            $0.action = #selector(copyFont(_:))
        }
    }

    var pasteFontMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste Style"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.target = self
            $0.action = #selector(pasteFont(_:))
        }
    }
}

public extension NSText {

    var alignLeftMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Align Left"
            $0.keyEquivalent = "{"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(alignLeft(_:))
        }
    }

    var alignCenterMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Center"
            $0.keyEquivalent = "i"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(alignCenter(_:))
        }
    }

    var alignRightMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Align Right"
            $0.keyEquivalent = "}"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(alignRight(_:))
        }
    }
}

public extension NSText {

    var toggleRulerMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Ruler"
            $0.target = self
            $0.action = #selector(toggleRuler(_:))
        }
    }

    var copyRulerMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy Ruler"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .control]
            $0.target = self
            $0.action = #selector(copyRuler(_:))
        }
    }

    var pasteRulerMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste Ruler"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .control]
            $0.target = self
            $0.action = #selector(pasteRuler(_:))
        }
    }
}
