//
// NSEvent+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSEvent {

    var recognizableModifierFlags: NSEventModifierFlags {
        return self.modifierFlags.intersection(.deviceIndependentFlagsMask)
    }
}
