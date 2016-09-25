/*
 * SnappingLayoutDelegate.swift
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

public protocol SnappingLayoutDelegate: class {

    var snappingPoint: CGPoint? { get set }
}

public extension SnappingLayoutDelegate where Self: UICollectionViewLayout {

    func snap(into point: CGPoint) {
        let proposedContentOffset = self.collectionView?.contentOffset ?? .zero
        let targetContentOffset = snappedContentOffset(forProposedContentOffset: proposedContentOffset, at: point)

        self.collectionView?.contentOffset = targetContentOffset
    }

    private func snappedLayoutAttribute(forProposedContentOffset contentOffset: CGPoint, at point: CGPoint) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }

        let distance: (UICollectionViewLayoutAttributes) -> CGFloat = {
            $0.center.convertToCoordinate(withOrigin: contentOffset).distance(to: point)
        }

        let rect = CGRect(origin: contentOffset, size: collectionView.bounds.size)

        return (self.layoutAttributesForElements(in: rect) ?? [])
            .filter { $0.representedElementCategory == .cell }.lazy
            .sorted { distance($0) < distance($1) }.lazy.first
    }

    internal func snappedContentOffset(forProposedContentOffset contentOffset: CGPoint, at point: CGPoint) -> CGPoint {
        return snappedLayoutAttribute(forProposedContentOffset: contentOffset, at: point)?
            .andThen { CGPoint(x: $0.center.x - point.x, y: $0.center.y - point.y) }
            ?? contentOffset
    }
}
