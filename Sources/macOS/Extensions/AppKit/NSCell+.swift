// 
// NSCell+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import AppKit

public extension NSCell {

    static var shared: NSCell {
        struct Singleton {

            static let value = NSCell().then {
                $0.wraps = true
            }
        }

        return Singleton.value
    }
}
