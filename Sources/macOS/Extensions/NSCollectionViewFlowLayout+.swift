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

    func delegateHeaderSizeInSection(_ index: Int) -> NSSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForHeaderInSection: index)
        }
    }

    func delegateFooterSizeInSection(_ index: Int) -> NSSize? {
        return zip(
            self.collectionView,
            self.collectionView?.delegate as? NSCollectionViewDelegateFlowLayout
        ).flatMap {
            $1.collectionView?($0, layout: self, referenceSizeForFooterInSection: index)
        }
    }
}
