//
// UICollectionViewFlowLayout+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import UIKit

public extension UICollectionViewFlowLayout {

    func delegateInsetForSection(at section: Int) -> UIEdgeInsets? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, insetForSectionAt: section)
    }

    func delegateMinimumLineSpacingForSection(at section: Int) -> CGFloat? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section)
    }

    func delegateMinimumInteritemSpacingForSection(at section: Int) -> CGFloat? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
    }

    func delegateReferenceSizeForHeader(in section: Int) -> CGSize? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section)
    }

    func delegateReferenceSizeForFooter(in section: Int) -> CGSize? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section)
    }
    
    func delegateSizeForCell(at indexPath: IndexPath) -> CGSize? {
        guard let collectionView = self.collectionView else { return nil }
        
        return collectionView.delegate
            .flatMap({ $0 as? UICollectionViewDelegateFlowLayout })?
            .collectionView?(collectionView, layout: self, sizeForItemAt: indexPath)
    }
}

public extension UICollectionViewFlowLayout {

    /// Return an estimated number of elements that are visible
    /// in bounds by using known layout attributes including item size,
    /// section insets, spacing, and scroll direction.
    ///
    /// - Warning: the calculation is only capable of simple flow layout.
    @available(*, deprecated)
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
