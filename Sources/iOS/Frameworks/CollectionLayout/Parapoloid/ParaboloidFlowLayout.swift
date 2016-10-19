/*
 * ParaboloidFlowLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

#if swift(>=3.0)
open class ParaboloidFlowLayout: SnappingFlowLayout {

    // MARK: Property

    open var paraboloidControler: ParaboloidLayoutController?

    open override class var layoutAttributesClass: AnyClass {
        return ParaboloidLayoutAttributes.self
    }

    // MARK: System Methods

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map {
            $0.representedElementCategory == .cell ? (self.layoutAttributesForItem(at: $0.indexPath) ?? $0) : $0
        }
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (super.layoutAttributesForItem(at: indexPath)?.copy() as? ParaboloidLayoutAttributes).flatMap {
            guard let contentOffset = self.collectionView?.contentOffset else { return nil }

            let center = $0.center.convertToCoordinate(ofOrigin: contentOffset)
            $0.paraboloidValue = paraboloidControler?.zValue(atPoint: center)

            return $0
        }
    }
}
#else
public class ParaboloidFlowLayout: SnappingFlowLayout {

    // MARK: Property

    public var paraboloidControler: ParaboloidLayoutController?

    // MARK: System Methods

    public override class func layoutAttributesClass() -> AnyClass {
        return ParaboloidLayoutAttributes.self
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map {
            $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ?? $0) : $0
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return (super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as? ParaboloidLayoutAttributes).flatMap {
            guard let contentOffset = self.collectionView?.contentOffset else { return nil }

            let center = $0.center.convertToCoordinateOfOrigin(contentOffset)
            $0.paraboloidValue = paraboloidControler?.zValue(atPoint: center)
            
            return $0
        }
    }
}
#endif
