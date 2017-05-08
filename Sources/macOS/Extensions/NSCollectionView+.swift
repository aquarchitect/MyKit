//
// NSCollectionView+.swift
// MyKit
//
// Created by Hai Nguyen on 4/30/17.
// Copyright (c) 2017 Hai Nguyen.
//

import AppKit

@available(OSX 10.11, *)
public extension NSCollectionView {

    func register<T: NSCollectionViewItem>(_ itemClass: T.Type) {
        self.register(itemClass, forItemWithIdentifier: String(describing: itemClass))
    }

    func makeItem<T: NSCollectionViewItem>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)

        return self.makeItem(withIdentifier: identifier, for: indexPath) as! T
    }
}
