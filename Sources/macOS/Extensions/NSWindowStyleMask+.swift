/*
 * NSWindowStyleMask+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSWindowStyleMask {

    /// The window is displays a close button, a minimize button, and a resize control.
    static var standard: NSWindowStyleMask {
        return [.closable, .resizable, .miniaturizable]
    }
}
