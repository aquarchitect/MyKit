//
//  MagnifyingIndentedLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/8/16.
//  
//

import UIKit

public class MagnifyingIndentedLayout: SnappingSuperLayout {

    // MARK: Property

    public var itemSize = CGSizeMake(50, 50)
    public var gridColumn: Int = 20
    public var iterimSpacing: CGFloat = 10

    public var magnifyingConfig = MagnifyingLayoutConfig()
    public var visibleAttributes: [NSIndexPath: UICollectionViewLayoutAttributes] = [:]

    private var itemsCount: Int {
        return (0..<(collectionView?.numberOfSections() ?? 0)).reduce(0) { $0 + (collectionView?.numberOfItemsInSection($1) ?? 0) }
    }

    // MARK: System Method

    public override func prepareLayout() {
        visibleAttributes.removeAll(keepCapacity: true)

        (0..<itemsCount).forEach {
            let column = $0 % gridColumn
            let row = $0 / gridColumn

            let x = CGFloat(column) * (itemSize.width + iterimSpacing) + CGFloat(row % 2) * itemSize.width / 2
            let y = CGFloat(row) * (itemSize.height + iterimSpacing)

            let origin = CGPointMake(x, y)
            let rect = CGRect(origin: origin, size: itemSize)

            !CGRectIntersectsRect(rect, self.collectionView?.bounds ?? .zero) ? () :
                NSIndexPath(forItem: $0, inSection: 0)
                    .then { UICollectionViewLayoutAttributes(forCellWithIndexPath: $0) }
                    .then { $0.frame = rect; visibleAttributes[$0.indexPath] = $0 }
        }
    }

    public override func collectionViewContentSize() -> CGSize {
        // add halft of the item size because of shifted odd rows
        let width = CGFloat(gridColumn) * (itemSize.width + iterimSpacing) - iterimSpacing + (itemSize.width / 2)
        let height = ceil(CGFloat(itemsCount) / CGFloat(gridColumn)) * (itemSize.height + iterimSpacing) - iterimSpacing
        return CGSizeMake(width, height)
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return visibleAttributes.keys.flatMap(self.layoutAttributesForItemAtIndexPath)
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return visibleAttributes[indexPath]?.then {
            guard let contentOffset = self.collectionView?.contentOffset else { return }

            let center = $0.center.shiftToCoordinate(contentOffset)
            let scale = magnifyingConfig.scaleAttributesAt(center)

            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
}