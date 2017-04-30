//
// NSCollectionView+.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

public extension NSCollectionView {

    @available(OSX 10.11, *)
    func register<T: NSCollectionViewItem>(_ itemClass: T.Type) {
        self.register(itemClass, forItemWithIdentifier: String(describing: itemClass))
    }
}
