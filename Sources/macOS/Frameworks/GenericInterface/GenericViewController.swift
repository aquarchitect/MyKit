// 
// GenericViewController.swift
// MyKit
// 
// Created by Hai Nguyen on 1/18/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

open class GenericViewController<V: NSView>: NSViewController {

    open override func loadView() {
        view = V()
    }
}
