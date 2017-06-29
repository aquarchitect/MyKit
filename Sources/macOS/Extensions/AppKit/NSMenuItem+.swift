// 
// NSMenuItem+.swift
// MyKit
// 
// Created by Hai Nguyen on 3/3/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

// MARK: - NSApplication Item

public extension NSMenuItem {

    static var orderFrontStandardAboutPanel: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "About \(Bundle.main.productName)"
            $0.action = #selector(NSApplication.orderFrontStandardAboutPanel(_:))
        }
    }

    static var orderFrontColorPanel: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Colors"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.action = #selector(NSApplication.orderFrontColorPanel(_:))
        }
    }

    static var preferences: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Preferences..."
            $0.keyEquivalent = ","
        }
    }

    static var hide: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Hide"
            $0.keyEquivalent = "h"
            $0.action = #selector(NSApplication.hide(_:))
        }
    }

    static var hideOtherApplications: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Hide Others"
            $0.keyEquivalent = "h"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.action = #selector(NSApplication.hideOtherApplications(_:))
        }
    }

    static var unhideAllApplications: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show All"
            $0.action = #selector(NSApplication.unhideAllApplications(_:))
        }
    }

    static var services: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Services"
        }
    }

    static var terminate: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Quit"
            $0.keyEquivalent = "q"
            $0.action = #selector(NSApplication.terminate(_:))
        }
    }

    static var runPageLayout: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Page Setup..."
            $0.keyEquivalent = "p"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.action = #selector(NSApplication.runPageLayout(_:))
        }
    }

    static var arrangeInFront: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Bring All to Front"
            $0.action = #selector(NSApplication.arrangeInFront(_:))
        }
    }

    static var showHelp: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Help"
            $0.keyEquivalent = "?"
            $0.action = #selector(NSApplication.showHelp(_:))
        }
    }
}

// MARK: - NSDocument Item

public extension NSMenuItem {

    static var save: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Save..."
            $0.keyEquivalent = "s"
            $0.action = #selector(NSDocument.save(_:))
        }
    }

    static var saveAs: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Save As..."
            $0.keyEquivalent = "s"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.action = #selector(NSDocument.saveAs(_:))
        }
    }

    static var revertToSaved: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Revert to Saved"
            $0.keyEquivalent = "r"
            $0.action = #selector(NSDocument.revertToSaved(_:))
        }
    }
}

// MARK: - UndoManager Item

public extension NSMenuItem {

    static var undo: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Undo"
            $0.keyEquivalent = "z"
            $0.action = #selector(UndoManager.undo)
        }
    }

    static var redo: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Redo"
            $0.keyEquivalent = "z"
            $0.keyEquivalentModifierMask = [.command, .shift]
            $0.action = #selector(UndoManager.redo)
        }
    }
}

// MARK: - NSText Item

public extension NSMenuItem {

    static var cut: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Cut"
            $0.keyEquivalent = "x"
            $0.action = #selector(NSText.cut(_:))
        }
    }

    @nonobjc static var copy: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy"
            $0.keyEquivalent = "c"
            $0.action = #selector(NSText.copy(_:))
        }
    }

    static var paste: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste"
            $0.keyEquivalent = "v"
            $0.action = #selector(NSText.paste(_:))
        }
    }

    static var delete: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Delete"
            $0.action = #selector(NSText.delete(_:))
        }
    }

    static var selectAll: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Select All"
            $0.keyEquivalent = "a"
            $0.action = #selector(NSText.selectAll(_:))
        }
    }

    static var showGuessPanel: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Spelling and Grammar"
            $0.keyEquivalent = ":"
            $0.action = #selector(NSText.showGuessPanel(_:))
        }
    }

    static var checkSpelling: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Document Now"
            $0.keyEquivalent = ";"
            $0.action = #selector(NSText.checkSpelling(_:))
        }
    }

    static var underline: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Underline"
            $0.keyEquivalent = "u"
            $0.action = #selector(NSText.underline(_:))
        }
    }

    static var copyFont: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy Style"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.action = #selector(NSText.copyFont(_:))
        }
    }

    static var pasteFont: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste Style"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.action = #selector(NSText.pasteFont(_:))
        }
    }

    static var alignLeft: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Align Left"
            $0.keyEquivalent = "{"
            $0.action = #selector(NSText.alignLeft(_:))
        }
    }

    static var alignCenter: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Center"
            $0.keyEquivalent = "i"
            $0.action = #selector(NSText.alignCenter(_:))
        }
    }

    static var alignRight: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Align Right"
            $0.keyEquivalent = "}"
            $0.action = #selector(NSText.alignRight(_:))
        }
    }

    static var toggleRuler: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Ruler"
            $0.target = self
            $0.action = #selector(NSText.toggleRuler(_:))
        }
    }

    static var copyRuler: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Copy Ruler"
            $0.keyEquivalent = "c"
            $0.keyEquivalentModifierMask = [.command, .control]
            $0.action = #selector(NSText.copyRuler(_:))
        }
    }

    static var pasteRuler: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste Ruler"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .control]
            $0.action = #selector(NSText.pasteRuler(_:))
        }
    }
}

// MARK: - NSResponder Item

public extension NSMenuItem {

    static var centerSelectionInVisibleArea: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Jump to Selection"
            $0.keyEquivalent = "j"
            $0.action = #selector(NSResponder.centerSelectionInVisibleArea(_:))
        }
    }

    static var makeBaseWritingDirectionNatural: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tDefault"
            $0.action = #selector(NSResponder.makeBaseWritingDirectionNatural(_:))
        }
    }

    static var makeBaseWritingDirectionLeftToRight: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tLeft to Right"
            $0.action = #selector(NSResponder.makeBaseWritingDirectionLeftToRight(_:))
        }
    }

    static var makeBaseWritingDirectionRightToLeft: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tRight to Left"
            $0.action = #selector(NSResponder.makeBaseWritingDirectionRightToLeft(_:))
        }
    }

    static var makeTextWritingDirectionNatural: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tDefault"
            $0.action = #selector(NSResponder.makeTextWritingDirectionNatural(_:))
        }
    }

    static var makeTextWritingDirectionLeftToRight: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tLeft to Right"
            $0.action = #selector(NSResponder.makeTextWritingDirectionLeftToRight(_:))
        }
    }

    static var makeTextWritingDirectionRightToLeft: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "\tRight to Left"
            $0.action = #selector(NSResponder.makeTextWritingDirectionRightToLeft(_:))
        }
    }
}

// MARK: - NSWindow Item

public extension NSMenuItem {

    static var performClose: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Close"
            $0.keyEquivalent = "w"
            $0.action = #selector(NSWindow.performClose(_:))
        }
    }

    static var print: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Print..."
            $0.keyEquivalent = "p"
            $0.action = #selector(NSWindow.print(_:))
        }
    }

    static var toggleToolbarShow: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Toolbar"
            $0.keyEquivalent = "t"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.action = #selector(NSWindow.toggleToolbarShown(_:))
        }
    }

    static var toggleFullScreen: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Enter Full Screen"
            $0.keyEquivalent = "f"
            $0.keyEquivalentModifierMask = [.command, .option]
            $0.action = #selector(NSWindow.toggleFullScreen(_:))
        }
    }

    static var runToolbarCustomizationPalette: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Customize Toolbar..."
            $0.action = #selector(NSWindow.runToolbarCustomizationPalette(_:))
        }
    }

    static var performMiniaturize: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Minimize"
            $0.keyEquivalent = "m"
            $0.action = #selector(NSWindow.performMiniaturize(_:))
        }
    }

    static var performZoom: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Zoom"
            $0.action = #selector(NSWindow.performZoom(_:))
        }
    }
}

// MARK: - NSDocumentController Item

public extension NSMenuItem {

    static var newDocument: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "New"
            $0.keyEquivalent = "n"
            $0.action = #selector(NSDocumentController.newDocument(_:))
        }
    }

    static var openDocument: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Open..."
            $0.keyEquivalent = "o"
            $0.action = #selector(NSDocumentController.openDocument(_:))
        }
    }

    static var openRecentDocument: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Open Recent"
            $0.submenu = NSMenu().then {
                $0.addItem(.clearRecentDocuments)
            }
        }
    }

    static var clearRecentDocuments: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Clear Menu"
            $0.action = #selector(NSDocumentController.clearRecentDocuments(_:))
        }
    }
}

// MARK: - NSTextView Item

public extension NSMenuItem {

    static var alignJustified: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Justify"
            $0.action = #selector(NSTextView.alignJustified(_:))
        }
    }

    static var pasteAsPlainText: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste and Match Style"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .shift, .option]
            $0.action = #selector(NSTextView.pasteAsPlainText(_:))
        }
    }

    static var performFindPanelAction: NSMenuItem {
        return NSMenuItem().then {
            $0.action = #selector(NSTextView.performFindPanelAction(_:))
        }
    }

    static var find: NSMenuItem {
        return performFindPanelAction.then {
            $0.title = "Find..."
            $0.keyEquivalent = "f"
        }
    }

    static var findAndReplace: NSMenuItem {
        return performFindPanelAction.then {
            $0.title = "Find and Replace..."
            $0.keyEquivalent = "f"
            $0.keyEquivalentModifierMask = [.command, .option]
        }
    }

    static var findNext: NSMenuItem {
        return performFindPanelAction.then {
            $0.title = "Find Next"
            $0.keyEquivalent = "g"
        }
    }

    static var findPrevious: NSMenuItem {
        return performFindPanelAction.then {
            $0.title = "Find Previous"
            $0.keyEquivalent = "g"
            $0.keyEquivalentModifierMask = [.command, .shift]
        }
    }

    static var useSelectionForFind: NSMenuItem {
        return performFindPanelAction.then {
            $0.title = "Use Selection for Find"
            $0.keyEquivalent = "e"
        }
    }

    static var toggleContinuousSpellChecking: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Spelling While Typing"
            $0.action = #selector(NSTextView.toggleContinuousSpellChecking(_:))
        }
    }

    static var toggleGrammarChecking: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Grammar With Spelling"
            $0.action = #selector(NSTextView.toggleGrammarChecking(_:))
        }
    }

    static var toggleAutomaticSpellingCorrection: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Correct Spelling Automatically"
            $0.action = #selector(NSTextView.toggleAutomaticSpellingCorrection(_:))
        }
    }

    static var orderFrontSubstitutionsPanel: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Substitutions"
            $0.action = #selector(NSTextView.orderFrontSubstitutionsPanel(_:))
        }
    }

    static var toggleSmartInsertDelete: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Copy/Paste"
            $0.action = #selector(NSTextView.toggleSmartInsertDelete(_:))
        }
    }

    static var toggleAutomaticQuoteSubstitution: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Quotes"
            $0.action = #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:))
        }
    }

    static var toggleAutomaticDashSubstitution: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Dashes"
            $0.action = #selector(NSTextView.toggleAutomaticDashSubstitution(_:))
        }
    }

    static var toggleAutomaticLinkDetection: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Links"
            $0.action = #selector(NSTextView.toggleAutomaticLinkDetection(_:))
        }
    }

    static var toggleAutomaticDataDetection: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Data Detectors"
            $0.action = #selector(NSTextView.toggleAutomaticDataDetection(_:))
        }
    }

    static var toggleAutomaticTextReplacement: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Text Replacement"
            $0.action = #selector(NSTextView.toggleAutomaticTextReplacement(_:))
        }
    }

    static var uppercaseWord: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Make Upper Case"
            $0.action = #selector(NSTextView.uppercaseWord(_:))
        }
    }

    static var lowercaseWord: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Make Lower Case"
            $0.action = #selector(NSTextView.lowercaseWord(_:))
        }
    }

    static var capitalizeWord: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Capitalize"
            $0.action = #selector(NSTextView.capitalizeWord(_:))
        }
    }

    static var startSpeaking: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Start Speaking"
            $0.action = #selector(NSTextView.startSpeaking(_:))
        }
    }

    static var stopSpeaking: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Stop Speaking"
            $0.target = self
            $0.action = #selector(NSTextView.stopSpeaking(_:))
        }
    }
}
