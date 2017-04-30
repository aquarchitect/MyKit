//
// NSEvent+.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSEvent {

    var recognizableModifierFlags: NSEventModifierFlags {
        return self.modifierFlags.intersection(.deviceIndependentFlagsMask)
    }
}
