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

@available(OSX 10.11, *)
public extension NSCollectionView {

    /// Return an estimated range of item indexes that are visible in bounds.
    ///
    /// The calculation uses `estimatedNumberOfVisibleElements` and only works 
    /// for a simple flow layout and single section collection view.
    var estimatedRangeOfVisibleItems: CountableRange<Int> {
        guard self.numberOfSections == 1,
            let flowLayout = self.collectionViewLayout as? NSCollectionViewFlowLayout,
            let minIndex = self.indexPathsForVisibleItems().min()?.item
            else { return 0..<0 }

        return minIndex..<(minIndex + flowLayout.estimatedNumberOfVisibleElements)
    }

    @available(*, deprecated, renamed: "estimatedRangeOfVisibleItems")
    var maximumRangeOfVisibleItems: CountableRange<Int> {
        return estimatedRangeOfVisibleItems
    }
}
