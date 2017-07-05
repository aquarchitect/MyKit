// 
// GenericCollectionItem.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import AppKit

open class GenericCollectionItem<V: NSView>: NSCollectionViewItem {

    open override func loadView() {
        view = V()
    }
}
