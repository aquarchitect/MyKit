//
// UICollectionViewFlowLayout+.swift
// MyKit
//
// Created by Hai Nguyen on 6/20/17.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit

public extension UICollectionViewFlowLayout {

    /// Return an estimated number of elements that are visible
    /// in bounds by using known layout attributes including item size,
    /// section insets, spacing, and scroll direction.
    ///
    /// - Warning: the calculation is only capable of simple flow layout.
    var estimatedNumberOfVisibleElements: Int {
        guard let collectionView = self.collectionView else { return 0 }

        switch self.scrollDirection {
        case .vertical:
            return Int((collectionView.bounds.height - self.sectionInset.vertical + self.minimumLineSpacing) / (self.itemSize.height + self.minimumLineSpacing))
        case .horizontal:
            return Int((collectionView.bounds.width - self.sectionInset.horizontal + self.minimumLineSpacing) / (self.itemSize.width + self.minimumInteritemSpacing))
        }
    }
}
