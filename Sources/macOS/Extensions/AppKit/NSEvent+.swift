//
// NSEvent+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSEvent {

#if swift(>=4.0)
    var recognizableModifierFlags: NSEvent.ModifierFlags {
        return self.modifierFlags.intersection(.deviceIndependentFlagsMask)
    }
#else
    var recognizableModifierFlags: NSEventModifierFlags {
        return self.modifierFlags.intersection(.deviceIndependentFlagsMask)
    }
#endif
}
