/*
 * SelectingLongPress.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

#if swift(>=3.0)
open class SelectingLongPress: UILongPressGestureRecognizer {

    /*
     * anchor: first started index path
     * track: last known touched index path
     */
    private var dragger: (anchorIndexPath: IndexPath, trackingIndexPath: IndexPath)?

    internal var collectionView: UICollectionView? {
        return self.view as? UICollectionView
    }

    open func handleGesture() {
        guard let touchingIndexPath = (collectionView.flatMap {
            (self.location(in:) >>> $0.indexPathForItem(at:))($0)
        }) else { return }


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
#else
public class SelectingLongPress: UILongPressGestureRecognizer {

    /*
     * anchor: first started index path
     * track: last known touched index path
     */
    private var dragger: (anchorIndexPath: NSIndexPath, trackingIndexPath: NSIndexPath)?

    internal var collectionView: UICollectionView? {
        return self.view as? UICollectionView
    }

    public func handleGesture() {
        guard let touchingIndexPath = (collectionView.flatMap {
            (self.locationInView >>> $0.indexPathForItemAtPoint)($0)
            }) else { return }


        switch self.state {
        case .Began:
            collectionView?.selectItemAtIndexPath(touchingIndexPath, animated: true, scrollPosition: .None)
            dragger = (touchingIndexPath, touchingIndexPath)
        case .Changed:
            _ = dragger.flatMap { selectCollectionViewItems(to: $0.trackingIndexPath) }
        default:
            dragger = nil
        }
    }

    func selectCollectionViewItems(to touchingIndexPath: NSIndexPath) {
        guard let anchorIndexPath = dragger?.anchorIndexPath,
            let trackingIndexPath = dragger?.trackingIndexPath
            else { return }

        guard let trackingIndexPathPredecessor = collectionView?.predecessorOfIndexPath(trackingIndexPath),
            let trackingIndexPathSucessor = collectionView?.successorOfIndexPath(trackingIndexPath)
            else { return }

        switch trackingIndexPath.compare(touchingIndexPath) {
        case .OrderedAscending:
            guard let cell = collectionView?.cellForItemAtIndexPath(trackingIndexPathSucessor) else { return }

            if trackingIndexPath != anchorIndexPath {
                if cell.selected {
                    collectionView?.selectItemAtIndexPath(trackingIndexPath, animated: false, scrollPosition: .None)
                } else {
                    collectionView?.deselectItemAtIndexPath(trackingIndexPath, animated: false)
                }
            }

            dragger?.trackingIndexPath = trackingIndexPathPredecessor
            selectCollectionViewItems(to: touchingIndexPath)
        case .OrderedDescending:
            guard let cell = collectionView?.cellForItemAtIndexPath(trackingIndexPathPredecessor) else { return }

            if trackingIndexPath != anchorIndexPath {
                if cell.selected {
                    collectionView?.selectItemAtIndexPath(trackingIndexPath, animated: false, scrollPosition: .None)
                } else {
                    collectionView?.deselectItemAtIndexPath(trackingIndexPath, animated: false)
                }
            }

            dragger?.trackingIndexPath = trackingIndexPathSucessor
            selectCollectionViewItems(to: touchingIndexPath)
        case .OrderedSame:
            collectionView?.selectItemAtIndexPath(trackingIndexPath, animated: true, scrollPosition: .None)
        }
    }
}
#endif
