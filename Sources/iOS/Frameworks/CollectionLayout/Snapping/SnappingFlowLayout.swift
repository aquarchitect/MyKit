//
//  SnappingFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/9/16.
//  
//

public class SnappingFlowLayout: UICollectionViewFlowLayout {

    public var snappingPoint: CGPoint? {
        didSet {
            guard let point = snappingPoint else { return }

            dispatch_async(Queue.Main) { [weak self] in
                guard let `self` = self else { return }

                let proposedContentOffset = self.collectionView?.contentOffset ?? .zero
                let targetContentOffset = self.snappedContentOffsetForProposedContentOffset(proposedContentOffset, atSnappingPoint: point)

                self.collectionView?.contentOffset = targetContentOffset
            }
        }
    }

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

        return (super.layoutAttributesForElementsInRect(rect) ?? [])
            .filter { $0.representedElementCategory == .Cell }.lazy
            .sort { distance($0) < distance($1) }.lazy.first
    }

    private func snappedContentOffsetForProposedContentOffset(contentOffset: CGPoint, atSnappingPoint point: CGPoint) -> CGPoint {
        return snappedLayoutAttributeForProposedContentOffset(contentOffset, atSnappingPoint: point)?
            .then { CGPointMake($0.center.x - point.x, $0.center.y - point.y) }
            ?? contentOffset
    }
}