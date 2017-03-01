/*
 * NSWindow+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSWindow {

    var performCloseMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Close"
            $0.keyEquivalent = "w"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(performClose(_:))
        }
    }

    var printMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Print..."
            $0.keyEquivalent = "p"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(self.print(_:))
        }
    }
}

public extension NSWindow {

    var toggleToolbarShownMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Toolbar"
            $0.keyEquivalent = "t"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.target = self
            $0.action = #selector(toggleToolbarShown(_:))
        }
    }

    var runToolbarCustomizationPaletteMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Customize Toolbar..."
            $0.target = self
            $0.action = #selector(runToolbarCustomizationPalette(_:))
        }
    }

    var toggleFullScreenMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Enter Full Screen"
            $0.keyEquivalent = "f"
            $0.keyEquivalentModifierMask = [.command, .control]
            $0.target = self
            $0.action = #selector(toggleFullScreen(_:))
        }
    }
}

public extension NSWindow {

    var performMiniaturizeMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Minimize"
            $0.keyEquivalent = "m"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(performMiniaturize(_:))
        }
    }

    var performZoomMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Zoom"
            $0.target = self
            $0.action = #selector(performZoom(_:))
        }
    }
}
