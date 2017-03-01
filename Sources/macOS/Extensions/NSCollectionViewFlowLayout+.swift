/*
 * NSCollectionViewFlowLayout+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

@available(OSX 10.11, *)
public extension NSCollectionViewFlowLayout {

    func delegateInset(for section: Int) -> EdgeInsets? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, insetForSectionAt: section)
        }
    }

    func delegateMinimumLineSpacing(for section: Int) -> CGFloat? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, minimumLineSpacingForSectionAt: section)
        }
    }

    func delegateMinimumInteritemSpacing(for section: Int) -> CGFloat? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, minimumInteritemSpacingForSectionAt: section)
        }
    }

    func delegateHeaderSize(in section: Int) -> NSSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForHeaderInSection: section)
        }
    }

    func delegateFooterSize(in section: Int) -> NSSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForFooterInSection: section)
        }
    }
}
