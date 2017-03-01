/*
 * NSTextView+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/28/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSTextView {

    var pasteAsPlainTextMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Paste and Match Style"
            $0.keyEquivalent = "v"
            $0.keyEquivalentModifierMask = [.command, .shift, .option]
            $0.target = self
            $0.action = #selector(pasteAsPlainText(_:))
        }
    }
}

public extension NSTextView {

    var performFindPanelActionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.target = self
            $0.action = #selector(performFindPanelAction(_:))
        }
    }

    var findMenuItem: NSMenuItem {
        return performFindPanelActionMenuItem.then {
            $0.title = "Find..."
            $0.keyEquivalent = "f"
            $0.keyEquivalentModifierMask = .command
        }
    }

    var findAndReplaceMenuItem: NSMenuItem {
        return performFindPanelActionMenuItem.then {
            $0.title = "Find and Replace..."
            $0.keyEquivalent = "f"
            $0.keyEquivalentModifierMask = [.command, .option]
        }
    }

    var findNextMenuItem: NSMenuItem {
        return performFindPanelActionMenuItem.then {
            $0.title = "Find Next"
            $0.keyEquivalent = "g"
            $0.keyEquivalentModifierMask = .command
        }
    }

    var findPreviousMenuItem: NSMenuItem {
        return performFindPanelActionMenuItem.then {
            $0.title = "Find Previous"
            $0.keyEquivalent = "g"
            $0.keyEquivalentModifierMask = [.command, .shift]
        }
    }

    var useSelectionForFindMenuItem: NSMenuItem {
        return performFindPanelActionMenuItem.then {
            $0.title = "Use Selection for Find"
            $0.keyEquivalent = "e"
            $0.keyEquivalentModifierMask = .command
        }
    }

    var findsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Find"
            $0.submenu = NSMenu().then {
                [
                    findMenuItem,
                    findAndReplaceMenuItem,
                    findNextMenuItem,
                    findPreviousMenuItem,
                    useSelectionForFindMenuItem,
                    centerSelectionInVisibleAreaMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}

public extension NSTextView {

    var toggleContinuousSpellCheckingMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Spelling While Typing"
            $0.target = self
            $0.action = #selector(toggleContinuousSpellChecking(_:))
        }
    }

    var toggleGrammarCheckingMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Check Grammar With Spelling"
            $0.target = self
            $0.action = #selector(toggleGrammarChecking(_:))
        }
    }

    var toggleAutomaticSpellingCorrectionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Correct Spelling Automatically"
            $0.target = self
            $0.action = #selector(toggleAutomaticSpellingCorrection(_:))
        }
    }

    var spellingAndGrammarMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Spelling and Grammar"
            $0.submenu = NSMenu().then {
                [
                    showGuessPanelMenuItem,
                    checkSpellingMenuItem,
                    .separator(),
                    toggleContinuousSpellCheckingMenuItem,
                    toggleGrammarCheckingMenuItem,
                    toggleAutomaticSpellingCorrectionMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}

public extension NSTextView {

    var orderFrontSubstitutionsPanelMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Show Substitutions"
            $0.target = self
            $0.action = #selector(orderFrontSubstitutionsPanel(_:))
        }
    }

    var toggleSmartInsertDeleteMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Copy/Paste"
            $0.target = self
            $0.action = #selector(toggleSmartInsertDelete(_:))
        }
    }

    var toggleAutomaticQuoteSubstitutionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Quotes"
            $0.target = self
            $0.action = #selector(toggleAutomaticQuoteSubstitution(_:))
        }
    }

    var toggleAutomaticDashSubstitutionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Dashes"
            $0.target = self
            $0.action = #selector(toggleAutomaticDashSubstitution(_:))
        }
    }

    var toggleAutomaticLinkDetectionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Smart Links"
            $0.target = self
            $0.action = #selector(toggleAutomaticLinkDetection(_:))
        }
    }

    var toggleAutomaticDataDetectionMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Data Detectors"
            $0.target = self
            $0.action = #selector(toggleAutomaticDataDetection(_:))
        }
    }

    var toggleAutomaticTextReplacementMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Text Replacement"
            $0.target = self
            $0.action = #selector(toggleAutomaticTextReplacement(_:))
        }
    }

    var substitutionsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Substitutions"
            $0.submenu = NSMenu().then {
                [
                    orderFrontSubstitutionsPanelMenuItem,
                    .separator(),
                    toggleSmartInsertDeleteMenuItem,
                    toggleAutomaticQuoteSubstitutionMenuItem,
                    toggleAutomaticDashSubstitutionMenuItem,
                    toggleAutomaticLinkDetectionMenuItem,
                    toggleAutomaticDataDetectionMenuItem,
                    toggleAutomaticTextReplacementMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}

public extension NSTextView {

    var uppercaseWordMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Make Upper Case"
            $0.target = self
            $0.action = #selector(uppercaseWord(_:))
        }
    }

    var lowercaseWordMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Make Lower Case"
            $0.target = self
            $0.action = #selector(lowercaseWord(_:))
        }
    }

    var capitalizeWordMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Capitalize"
            $0.target = self
            $0.action = #selector(capitalizeWord(_:))
        }
    }

    var transformationsMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Transformations"
            $0.submenu = NSMenu().then {
                [
                    uppercaseWordMenuItem,
                    lowercaseWordMenuItem,
                    capitalizeWordMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}

public extension NSTextView {

    var startSpeakingMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Start Speaking"
            $0.target = self
            $0.action = #selector(startSpeaking(_:))
        }
    }

    var stopSpeakingMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Stop Speaking"
            $0.target = self
            $0.action = #selector(stopSpeaking(_:))
        }
    }

    var speechMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Speech"
            $0.submenu = NSMenu().then {
                [
                    startSpeakingMenuItem,
                    stopSpeakingMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}

public extension NSTextView {

    var alignJustifiedMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Justify"
            $0.target = self
            $0.action = #selector(alignJustified(_:))
        }
    }

    var textMenuItem: NSMenuItem {
        return NSMenuItem().then {
            $0.title = "Text"
            $0.submenu = NSMenu().then {
                [
                    alignLeftMenuItem,
                    alignCenterMenuItem,
                    alignJustifiedMenuItem,
                    alignRightMenuItem,
                    .separator(),
                    writingDirectionMenuItem,
                    .separator(),
                    toggleRulerMenuItem,
                    copyRulerMenuItem,
                    pasteMenuItem
                ].forEach($0.addItem)
            }
        }
    }
}
