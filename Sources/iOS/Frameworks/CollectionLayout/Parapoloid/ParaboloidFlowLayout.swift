/*
 * ParaboloidFlowLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public class ParaboloidFlowLayout: SnappingFlowLayout {

    // MARK: Property

    public var paraboloidControler: ParaboloidLayoutController?

    public override class var layoutAttributesClass: AnyClass {
        return ParaboloidLayoutAttributes.self
    }

    // MARK: System Methods


    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map {
            $0.representedElementCategory == .cell ? (self.layoutAttributesForItem(at: $0.indexPath) ?? $0) : $0
        }
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (super.layoutAttributesForItem(at: indexPath as IndexPath)?.copy() as? ParaboloidLayoutAttributes).flatMap {
            guard let contentOffset = self.collectionView?.contentOffset else { return nil }

            let center = $0.center.convertToCoordinate(withOrigin: contentOffset)
            $0.paraboloidValue = paraboloidControler?.zValue(atPoint: center)

            return $0
        }
    }
}
