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
