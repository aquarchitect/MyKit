// 
// GenericViewController.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

open class GenericViewController<V: NSView>: NSViewController {

    open override func loadView() {
        view = V()
    }
}
