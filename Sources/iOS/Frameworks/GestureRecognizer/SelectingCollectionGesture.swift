// 
// SelectingCollectionGesture.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

/// Multiple select collection cell by dragging with long press gesture.
open class SelectingCollectionGesture: UILongPressGestureRecognizer {

    // MARK: Properties

    // anchor: first started index path
    // track: last known touched index path
    private var dragger: (anchorIndexPath: IndexPath, trackingIndexPath: IndexPath)?

    internal var collectionView: UICollectionView? {
        return self.view as? UICollectionView
    }

    // MARK: Initialization

    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(handleGesture))
    }

    // MARK: Helper Methods

    @objc open func handleGesture() {
        guard let touchingIndexPath = collectionView.flatMap({ (self.location(in:) >>> $0.indexPathForItem(at:))($0) })
            else { return }

        switch self.state {

        case .began:
            collectionView?.selectItem(at: touchingIndexPath, animated: true, scrollPosition: [])
            dragger = (touchingIndexPath, touchingIndexPath)

        case .changed:
            dragger.flatMap { selectCollectionViewItems(to: $0.trackingIndexPath) }

        default:
            dragger = nil
        }
    }

    func selectCollectionViewItems(to touchingIndexPath: IndexPath) {
        guard let anchorIndexPath = dragger?.anchorIndexPath,
            let trackingIndexPath = dragger?.trackingIndexPath
            else { return }

        guard let trackingIndexPathPredecessor = collectionView?.indexPath(before: trackingIndexPath),
            let trackingIndexPathSucessor = collectionView?.indexPath(after: trackingIndexPath)
            else { return }

        switch trackingIndexPath.compare(touchingIndexPath) {

        case .orderedAscending:
            guard let cell = collectionView?.cellForItem(at: trackingIndexPathSucessor) else { return }

            if trackingIndexPath != anchorIndexPath {
                if cell.isSelected {
                    collectionView?.selectItem(at: trackingIndexPath, animated: false, scrollPosition: [])
                } else {
                    collectionView?.deselectItem(at: trackingIndexPath, animated: false)
                }
            }

            dragger?.trackingIndexPath = trackingIndexPathPredecessor
            selectCollectionViewItems(to: touchingIndexPath)

        case .orderedDescending:
            guard let cell = collectionView?.cellForItem(at: trackingIndexPathPredecessor) else { return }

            if trackingIndexPath != anchorIndexPath {
                if cell.isSelected {
                    collectionView?.selectItem(at: trackingIndexPath, animated: false, scrollPosition: [])
                } else {
                    collectionView?.deselectItem(at: trackingIndexPath, animated: false)
                }
            }

            dragger?.trackingIndexPath = trackingIndexPathSucessor
            selectCollectionViewItems(to: touchingIndexPath)
            
        case .orderedSame:
            collectionView?.selectItem(at: trackingIndexPath, animated: true, scrollPosition: [])
        }
    }
}
