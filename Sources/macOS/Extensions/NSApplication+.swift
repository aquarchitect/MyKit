/*
 * NSApplication+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

// MARK: - Application Menu

public extension NSApplication {

    var orderFrontStandardAboutPanelMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "About"
            $0.target = self
            $0.action = #selector(orderFrontStandardAboutPanel(_:))
        }
    }

    var orderFrontColorPanelMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Colors"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.target = self
            $0.action = #selector(orderFrontColorPanel(_:))
        }
    }

    var preferencesMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Preferences..."
            $0.keyEquivalent = ","
            $0.keyEquivalentModifierMask = .command
        }
    }

    var hideMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Hide"
            $0.keyEquivalent = "h"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(hide(_:))
        }
    }

    var hideOtherApplicationsMenutItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Hide Others"
            $0.keyEquivalent = "h"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.target = self
            $0.action = #selector(hideOtherApplications(_:))
        }
    }

    var unhideAllApplicationsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show All"
            $0.target = self
            $0.action = #selector(unhideAllApplications (_:))
        }
    }

    var servicesMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Services"
            $0.submenu = self.servicesMenu
        }
    }

    var terminateMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Quit"
            $0.keyEquivalent = "q"
            $0.keyEquivalentModifierMask = .command
            $0.target = self
            $0.action = #selector(terminate(_:))
        }
    }

    var runPageLayoutMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Page Setup..."
            $0.keyEquivalent = "p"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.target = self
            $0.action = #selector(runPageLayout(_:))
        }
    }

    var arrangeInFrontMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Bring All to Front"
            $0.target = self
            $0.action = #selector(arrangeInFront(_:))
        }
    }

    var showHelpMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Test"
            $0.target = self
            $0.action = #selector(showHelp(_:))
        }
    }
}
