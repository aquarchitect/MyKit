// 
// NSMenu+.swift
// MyKit
// 
// Created by Hai Nguyen on 3/3/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

public extension NSMenu {

    static var find: NSMenu {
        return NSMenu(title: "Find").then {
            [
                .find,
                .findAndReplace,
                .findNext,
                .findPrevious,
                .useSelectionForFind,
                .centerSelectionInVisibleArea
            ].forEach($0.addItem)
        }
    }

    static var text: NSMenu {
        return NSMenu(title: "Text").then {
            [
                .alignLeft,
                .alignCenter,
                .alignJustified,
                .alignRight,
                .separator(),
                NSMenuItem().then {
                    $0.title = "Writing Direction"
                    $0.submenu = .writingDirection
                },
                .separator(),
                .toggleRuler,
                .copyRuler,
                .paste
            ].forEach($0.addItem)
        }
    }

    static var speech: NSMenu {
        return NSMenu(title: "Speech").then {
            [
                .startSpeaking,
                .stopSpeaking
            ].forEach($0.addItem)
        }
    }

    static var transformations: NSMenu {
        return NSMenu(title: "Transformations").then {
            [
                .uppercaseWord,
                .lowercaseWord,
                .capitalizeWord
            ].forEach($0.addItem)
        }
    }

    static var writingDirection: NSMenu {
        return NSMenu(title: "Writing Direction").then {
            [
                NSMenuItem(title: "Paragraph", action: nil, keyEquivalent: ""),
                .makeBaseWritingDirectionNatural,
                .makeBaseWritingDirectionLeftToRight,
                .makeBaseWritingDirectionRightToLeft,
                .separator(),
                NSMenuItem(title: "Selection", action: nil, keyEquivalent: ""),
                .makeTextWritingDirectionNatural,
                .makeTextWritingDirectionLeftToRight,
                .makeTextWritingDirectionRightToLeft
            ].forEach($0.addItem)
        }
    }

    static var spellingAndGrammar: NSMenu {
        return NSMenu().then {
            $0.title = "Spelling and Grammer"
            [
                .showGuessPanel,
                .checkSpelling,
                .separator(),
                .toggleContinuousSpellChecking,
                .toggleGrammarChecking,
                .toggleAutomaticSpellingCorrection
            ].forEach($0.addItem)
        }
    }

    static var substitutions: NSMenu {
        return NSMenu(title: "Substitutions").then {
            [
                .orderFrontSubstitutionsPanel,
                .separator(),
                .toggleSmartInsertDelete,
                .toggleAutomaticQuoteSubstitution,
                .toggleAutomaticDashSubstitution,
                .toggleAutomaticLinkDetection,
                .toggleAutomaticDataDetection,
                .toggleAutomaticTextReplacement
            ].forEach($0.addItem)
        }
    }
}

public extension NSMenu {

    static var application: NSMenu {
        return NSMenu().then {
            [
                .orderFrontStandardAboutPanel,
                .separator(),
                .preferences,
                .separator(),
                .services,
                .hide,
                .hideOtherApplications,
                .unhideAllApplications,
                .separator(),
                .terminate
            ].forEach($0.addItem)
        }
    }

    static var file: NSMenu {
        return NSMenu(title: "Find").then {
            [
                .newDocument,
                .openDocument,
                .openRecentDocument,
                .separator(),
                .performClose,
                .save,
                .saveAs,
                .revertToSaved,
                .separator(),
                .runPageLayout,
                .print
            ].forEach($0.addItem)
        }
    }

    static var edit: NSMenu {
        return NSMenu(title: "Edit").then {
            [
                .undo,
                .redo,
                .separator(),
                .cut,
                .copy,
                .paste,
                .pasteAsPlainText,
                .delete,
                .selectAll,
                .separator(),
                NSMenuItem().then {
                    $0.title = "Find"
                    $0.submenu = .find
                },
                NSMenuItem().then {
                    $0.title = "Spelling and Grammar"
                    $0.submenu = .spellingAndGrammar
                },
                NSMenuItem().then {
                    $0.title = "Substitutions"
                    $0.submenu = .substitutions
                },
                NSMenuItem().then {
                    $0.title = "Transformations"
                    $0.submenu = .transformations
                },
                NSMenuItem().then {
                    $0.title = "Speech"
                    $0.submenu = .speech
                }
            ].forEach($0.addItem)
        }
    }

    static var format: NSMenu {
        return NSMenu(title: "Format").then {
            [
                NSMenuItem().then {
                    $0.title = "Font"
                    $0.submenu = NSFontManager.shared().fontMenu(true)
                },
                NSMenuItem().then {
                    $0.title = "Text"
                    $0.submenu = .text
                }
            ].forEach($0.addItem)
        }
    }

    static var view: NSMenu {
        return NSMenu(title: "View").then {
            [
                .toggleToolbarShow,
                .runToolbarCustomizationPalette,
                .separator(),
                .toggleFullScreen
            ].forEach($0.addItem)
        }
    }

    static var window: NSMenu {
        return NSMenu(title: "Window").then {
            [
                .performMiniaturize,
                .performZoom,
                .separator(),
                .arrangeInFront
            ].forEach($0.addItem)
        }
    }

    static var help: NSMenu {
        return NSMenu(title: "Help").then {
            $0.addItem(.showHelp)
        }
    }
}

public extension NSMenu {

    static var mainStandard: NSMenu {
        return NSMenu(title: "Main Menu").then {
            [
                .application,
                .file,
                .edit,
                .format,
                .view,
                .window,
                .help
            ].map { menu in
                NSMenuItem().then {
                    $0.submenu = menu
                }
            }.forEach($0.addItem)
        }
    }
}
