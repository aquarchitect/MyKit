// 
// GenericCollectionItem.swift
// MyKit
// 
// Created by Hai Nguyen on 11/7/16.
// Copyright (c) 2016 Hai Nguyen.
// 

import AppKit

open class GenericCollectionItem<V: NSView>: NSCollectionViewItem {

    open override func loadView() {
        view = V()
    }
}
