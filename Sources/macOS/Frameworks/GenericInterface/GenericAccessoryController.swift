/*
 * GenericAccessoryController.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

open class GenericAccessoryController<V: NSView>: NSTitlebarAccessoryViewController {

    open override func loadView() {
        view = V()
    }
}
