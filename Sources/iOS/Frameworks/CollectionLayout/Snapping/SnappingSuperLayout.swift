/*
 * SnappingSuperLayout.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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

public class SnappingSuperLayout: UICollectionViewLayout {

    public var snappingPoint: CGPoint?

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let point = snappingPoint {
            return snappedContentOffsetForProposedContentOffset(proposedContentOffset, atSnappingPoint: point)
        } else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
    }

    private func snappedLayoutAttributeForProposedContentOffset(contentOffset: CGPoint, atSnappingPoint point: CGPoint) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }

        let distance: UICollectionViewLayoutAttributes -> CGFloat = {
            let center = $0.center.shiftToCoordinate(contentOffset)
            return CGPointDistanceToPoint(center, point)
        }

        let rect = CGRect(origin: contentOffset, size: collectionView.bounds.size)

        return (self.layoutAttributesForElementsInRect(rect) ?? [])
            .filter { $0.representedElementCategory == .Cell }.lazy
            .sort { distance($0) < distance($1) }.lazy.first
    }

    private func snappedContentOffsetForProposedContentOffset(contentOffset: CGPoint, atSnappingPoint point: CGPoint) -> CGPoint {
        return snappedLayoutAttributeForProposedContentOffset(contentOffset, atSnappingPoint: point)?
            .andThen { CGPointMake($0.center.x - point.x, $0.center.y - point.y) }
            ?? contentOffset
    }
}