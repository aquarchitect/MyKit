// 
// NSCollectionViewFlowLayout+.swift
// MyKit
// 
// Created by Hai Nguyen on 3/1/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import AppKit

@available(OSX 10.11, *)
public extension NSCollectionViewFlowLayout {

    func delegateInsetForSection(at index: Int) -> EdgeInsets? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, insetForSectionAt: index)
        }
    }

    func delegateMinimumLineSpacingForSection(at index: Int) -> CGFloat? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, minimumLineSpacingForSectionAt: index)
        }
    }

    func delegateMinimumInteritemSpacingForSection(at index: Int) -> CGFloat? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, minimumInteritemSpacingForSectionAt: index)
        }
    }

    func delegateHeaderSizeInSection(_ index: Int) -> CGSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForHeaderInSection: index)
        }
    }

    func delegateFooterSizeInSection(_ index: Int) -> CGSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForFooterInSection: index)
        }
    }
}

@available(OSX 10.11, *)
public extension NSCollectionViewFlowLayout {

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

    @available(*, deprecated, renamed: "estimatedNumberOfVisibleElements")
    var maximumNumberOfVisibleElements: Int {
        return estimatedNumberOfVisibleElements
    }
}
