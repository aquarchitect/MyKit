// 
// NSWindow.StyleMask+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

#if swift(>=4.0)
public extension NSWindow.StyleMask {

    /// The window is displays a close button, a minimize button, and a resize control.
    static var standard: NSWindow.StyleMask {
        return [.closable, .resizable, .miniaturizable]
    }
}
#else
public extension NSWindowStyleMask {
    
    /// The window is displays a close button, a minimize button, and a resize control.
    static var standard: NSWindowStyleMask {
        return [.closable, .resizable, .miniaturizable]
    }
}
#endif
