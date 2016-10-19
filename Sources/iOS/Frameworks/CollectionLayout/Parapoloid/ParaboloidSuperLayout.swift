/*
 * ParaboloidSuperLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

open class ParaboloidSuperLayout: SnappingSuperLayout {

    open override class var layoutAttributesClass: AnyClass {
        return ParaboloidLayoutAttributes.self
    }

    open var paraboloidController: ParaboloidLayoutController?
    open var visibleAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return visibleAttributes.keys.flatMap(self.layoutAttributesForItem)
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (visibleAttributes[indexPath] as? ParaboloidLayoutAttributes).flatMap {
            guard let contentOffset = self.collectionView?.contentOffset else { return nil }

            let center = $0.center.convertToCoordinate(ofOrigin: contentOffset)
            $0.paraboloidValue = paraboloidController?.zValue(atPoint: center)

            return $0
        }
    }
}
