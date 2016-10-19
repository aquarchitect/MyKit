/*
 * SnappingSuperLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

#if swift(>=3.0)
open class SnappingSuperLayout: UICollectionViewLayout, SnappingLayoutDelegate {

    open var snappingPoint: CGPoint? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.snappingPoint.flatMap(self.snap(into:))
            }
        }
    }

    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let point = snappingPoint {
            return snappedContentOffset(forProposedContentOffset: proposedContentOffset, at: point)
        } else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
    }
}
#else
public class SnappingSuperLayout: UICollectionViewLayout, SnappingLayoutDelegate {

    public var snappingPoint: CGPoint? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                guard let `self` = self else { return }
                _ = self.snappingPoint.flatMap(self.snap(into:))
            }
        }
    }

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let point = snappingPoint {
            return snappedContentOffset(forProposedContentOffset: proposedContentOffset, at: point)
        } else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
    }
}
#endif
