/*
 * SnappingLayoutDelegate.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
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

    func snappedLayoutAttribute(forProposedContentOffset contentOffset: CGPoint, at point: CGPoint) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }

#if swift(>=3.0)
        let distance: (UICollectionViewLayoutAttributes) -> CGFloat = {
            $0.center.convertToCoordinate(ofOrigin: contentOffset).distance(from: point)
        }
#else
        let distance: (UICollectionViewLayoutAttributes) -> CGFloat = {
            $0.center.convertToCoordinateOfOrigin(contentOffset).distanceFromPoint(point)
        }
#endif

        let rect = CGRect(origin: contentOffset, size: collectionView.bounds.size)

#if swift(>=3.0)
        return (self.layoutAttributesForElements(in: rect) ?? [])
            .lazy
            .filter { $0.representedElementCategory == .cell }
            .sorted { distance($0) < distance($1) }
            .first
#else
        return (self.layoutAttributesForElementsInRect(rect) ?? [])
            .lazy
            .filter { $0.representedElementCategory == .Cell }
            .sort { distance($0) < distance($1) }
            .first
#endif
    }

    internal func snappedContentOffset(forProposedContentOffset contentOffset: CGPoint, at point: CGPoint) -> CGPoint {
        return snappedLayoutAttribute(forProposedContentOffset: contentOffset, at: point)
            .map { CGPoint(x: $0.center.x - point.x, y: $0.center.y - point.y) }
            ?? contentOffset
    }
}
