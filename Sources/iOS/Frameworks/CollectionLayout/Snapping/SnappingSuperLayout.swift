// 
// SnappingSuperLayout.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

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

