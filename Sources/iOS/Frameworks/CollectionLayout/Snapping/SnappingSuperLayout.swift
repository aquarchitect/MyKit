//
//  SnappingSuperLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/9/16.
//  
//

public class SnappingSuperLayout: UICollectionViewLayout {

    public var snappingPoint: CGPoint?

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let point = snappingPoint {
            return snappingContentOffset(for: proposedContentOffset, atPoint: point)
        } else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
    }
}
