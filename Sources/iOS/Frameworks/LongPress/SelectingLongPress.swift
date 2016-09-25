/*
 * SelectingLongPress.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public class SelectingLongPress: UILongPressGestureRecognizer {

    /*
     * anchor: first started index path
     * track: last known touched index path
     */
    private var dragger: (anchorIndexPath: IndexPath, trackingIndexPath: IndexPath)?

    internal var collectionView: UICollectionView? {
        return self.view as? UICollectionView
    }

    public func handleGesture() {
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

    internal func selectCollectionViewItems(to touchingIndexPath: IndexPath) {
        guard let anchorIndexPath = dragger?.anchorIndexPath,
            let trackingIndexPath = dragger?.trackingIndexPath
            else { return }

        guard let trackingIndexPathPredecessor = collectionView?.formIndexPath(before: trackingIndexPath),
            let trackingIndexPathSucessor = collectionView?.formIndexPath(after: trackingIndexPath)
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
