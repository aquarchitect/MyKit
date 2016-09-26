/*
 * ParaboloidSuperLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

public class ParaboloidSuperLayout: SnappingSuperLayout {

    public override class var layoutAttributesClass: AnyClass {
        return ParaboloidLayoutAttributes.self
    }

    public var paraboloidController: ParaboloidLayoutController?
    public var visibleAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return visibleAttributes.keys.flatMap(self.layoutAttributesForItem)
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (visibleAttributes[indexPath] as? ParaboloidLayoutAttributes).flatMap {
            guard let contentOffset = self.collectionView?.contentOffset else { return nil }

            let center = $0.center.convertToCoordinate(withOrigin: contentOffset)
            $0.paraboloidValue = paraboloidController?.zValue(atPoint: center)

            return $0
        }
    }
}
